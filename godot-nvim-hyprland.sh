#!/usr/bin/env bash

# Godot-Neovim Wrapper Script for Hyprland
# This script opens files in Neovim and switches to the correct workspace

SOCKET_PATH="./godothost"
FILE="$1"
LINE="$2"
COL="$3"

find_terminal_pid() {
    local pid=$1
    local max_depth=10
    local depth=0
    
    while [ $depth -lt $max_depth ] && [ "$pid" != "1" ] && [ -n "$pid" ]; do
        # Check if this process is ghostty by checking the process name
        local proc_name=$(ps -o comm= -p "$pid" 2>/dev/null)
        
        if [ "$proc_name" = ".ghostty-wrappe" ]; then
            echo "$pid"
            return 0
        fi
        
        # Get parent PID
        pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
        depth=$((depth + 1))
    done
    
    return 1
}

# Function to find the workspace with the nvim instance
find_nvim_workspace() {
    # Try to find by checking which nvim process is listening to our socket
    local nvim_pid=$(lsof -t "$SOCKET_PATH" 2>/dev/null)

    if [ -n "$nvim_pid" ]; then
	# Get the parent process (Ghostty terminal) PID
        # local terminal_pid=$(ps -o ppid= -p "$nvim_pid" | tr -d ' ')
	local terminal_pid=$(find_terminal_pid "$nvim_pid")
        
        # Find the window with the terminal PID
        local workspace=$(hyprctl clients -j | jq -r ".[] | select(.pid == $terminal_pid) | .workspace.id" | head -n 1)
        
        if [ -n "$workspace" ]; then
            echo "$workspace"
        else
            # Fallback: find any ghostty/nvim window by title
            hyprctl clients -j | jq -r '.[] | select(.class == "com.mitchellh.ghostty" and (.title | type == "string" and (contains("nvim") or contains("vim")))) | .workspace.id' | head -n 1
        fi
    else
        # Fallback: find any ghostty/nvim window by title
        hyprctl clients -j | jq -r '.[] | select(.class == "com.mitchellh.ghostty" and (.title | type == "string" and (contains("nvim") or contains("vim")))) | .workspace.id' | head -n 1
    fi
}

# Function to check if nvim server is running
is_server_running() {
    nvim --server "$SOCKET_PATH" --remote-expr "1" &>/dev/null
    return $?
}

# Check if server is already running
if is_server_running; then
    # Server exists, find its workspace
    WORKSPACE=$(find_nvim_workspace)
    
    if [ -n "$WORKSPACE" ]; then
        # Switch to the workspace
        hyprctl dispatch workspace "$WORKSPACE"
    fi
    
    # Open the file in the existing instance
    nvim --server "$SOCKET_PATH" --remote-send "<C-\><C-N>:n $FILE<CR>${LINE}G${COL}|"
else
    # No server running, start a new nvim instance
    # Launch in a new terminal with Ghostty
    ghostty -e nvim --listen "$SOCKET_PATH" "$FILE" &
    
    # Wait a moment for the window to appear
    sleep 0.5
    
    nvim --server "$SOCKET_PATH" --remote-send "<C-\><C-N>:n $FILE<CR>${LINE}G${COL}|"

    # Focus the new window
    WORKSPACE=$(find_nvim_workspace)
    if [ -n "$WORKSPACE" ]; then
        hyprctl dispatch workspace "$WORKSPACE"
    fi
fi

