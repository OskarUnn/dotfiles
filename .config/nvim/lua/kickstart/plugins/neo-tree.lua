-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '<C-n>', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      filtered_items = {
        -- visible = false, -- when true, they will just be displayed differently than normal items
        -- hide_dotfiles = false,
        -- hide_gitignored = false,
        -- hide_hidden = true, -- only works on Windows for hidden files/directories
        -- hide_by_name = {
        --   '.godot',
        -- },
        hide_by_pattern = { -- uses glob style patterns
          '*.import',
          '*.uid',
        },
        -- always_show = { -- remains visible even if other settings would normally hide it
        --   '.gitignored',
        -- },
        -- never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
        -- },
      },
      window = {
        mappings = {
          ['<C-n>'] = 'close_window',
        },
      },
    },
  },
}
