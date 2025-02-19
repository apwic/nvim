return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    -- Tokyonight
    -- 'folke/tokyonight.nvim',
    -- priority = 1000, -- Make sure to load this before all the other start plugins.
    -- init = function()
    --   -- Load the colorscheme here.
    --   -- Like many other themes, this one has different styles, and you could load
    --   -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    --   vim.cmd.colorscheme 'tokyonight-night'
    --
    --   -- You can configure highlights by doing something like:
    --   vim.cmd.hi 'Comment gui=none'
    -- end,
  },
  -- -- Gruvbox
  -- {
  --   'ellisonleao/gruvbox.nvim',
  --   priority = 1000,
  --   config = true,
  --   opts = ...,
  --   init = function()
  --     vim.cmd.colorscheme 'gruvbox'
  --   end,
  -- },
  -- -- Rose Pine
  -- {
  --   'rose-pine/neovim',
  --   name = 'rose-pine',
  --   config = function()
  --     vim.cmd 'colorscheme rose-pine-moon'
  --   end,
  -- },
  -- Catpuccin
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'catppuccin-macchiato'
    end,
  },
}
