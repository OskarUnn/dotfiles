#!/usr/bin/env bash

# Script originally sourced from: https://github.com/janmar6/wayland-dotfiles/blob/main/hypr/scripts/audio.sh

notiftime="500"
volume_before=$(pamixer --get-volume)
case $1 in
    # 5)
    #     # rounding to multiples of 5
    #     rounded_brightness=$(( volume_before / 5 * 5 ))
    #     pamixer --set-volume $((rounded_brightness + 5))
    #     ;;
    # -5)
    #     # rounding to multiples of 5
    #     rounded_brightness=$(( (volume_before + 4) / 5 * 5 ))
    #     pamixer --set-volume $((rounded_brightness - 5))
    #     ;;
    1)
        pamixer --increase 1
        ;;
    -1)
        pamixer --decrease 1
        ;;
    "mute")
        if [ "$(pamixer --get-mute)" == "false" ]; then
            pamixer --mute
            notify-send "Muted" -r 40 -t "$notiftime"
            exit
        fi
        ;;
    *)
        # rounding to multiples of 5
        value="$1"
        volume=$(( volume_before + value ))
        if [ "$value" -lt 0 ]; then
            rounded_volume=$(( (volume + 4) / 5 * 5 ))
            pamixer --set-volume "$rounded_volume"
        elif [ "$value" -gt 0 ]; then
            rounded_volume=$(( volume / 5 * 5 ))
            pamixer --set-volume "$rounded_volume"
        else
            echo "error: argument must be 5; -5; 1; -1 or mute"
            exit 1
        fi
        ;;
esac

current_volume=$(pamixer --get-volume)
if [[ current_volume -eq 0 ]]; then
    pamixer --mute
    # notify-send -h int:value:"$current_volume" "Volume: $current_volume%" -r 40
    notify-send "Muted" -r 40 -t "$notiftime"
    exit 0
fi

pamixer --unmute
notify-send -h int:value:"$current_volume" "Volume: $current_volume%" -r 40 -t "$notiftime"
