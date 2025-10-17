require "nvchad.options"

-- add yours here!

vim.opt.scrolloff = 5

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

vim.opt.guicursor = {
  "n-v-c:block-Cursor",        -- block cursor with custom highlight in normal/visual/command mode
  "i-ci-ve:ver25-Cursor",      -- vertical bar in insert mode
  "r-cr:hor20-Cursor",         -- horizontal bar in replace mode
  "o:hor50-Cursor",            -- horizontal bar for operator-pending
  -- "a:blinkon0"                 -- disable blinking
}

vim.api.nvim_set_hl(0, "Cursor", { reverse = true })

