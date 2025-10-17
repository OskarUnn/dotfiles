return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  
  {
  "sphamba/smear-cursor.nvim",
    lazy = false,
    opts = {
          -- Smear cursor when switching buffers or windows.
          smear_between_buffers = true,

          -- Smear cursor when moving within line or to neighbor lines.
          -- Use `min_horizontal_distance_smear` and `min_vertical_distance_smear` for finer control
          smear_between_neighbor_lines = true,

          -- Draw the smear in buffer space instead of screen space when scrolling
          scroll_buffer_space = true,

          -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
          -- Smears will blend better on all backgrounds.
          legacy_computing_symbols_support = false,

          -- Smear cursor in insert mode.
          -- See also `vertical_bar_cursor_insert_mode` and `distance_stop_animating_vertical_bar`.
          smear_insert_mode = true,
    },
  },

  -- test new blink
  { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
