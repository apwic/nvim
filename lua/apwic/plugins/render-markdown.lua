return {
  'MeanderingProgrammer/render-markdown.nvim',
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  config = function()
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    require('render-markdown').setup {
      -- prefer to not attach on default
      enabled = false,
    }
    -- map to attach on need
    vim.keymap.set('n', '<leader>m', '<CMD>RenderMarkdown toggle<CR>', { desc = '[M]arkdown Preview Toggle' })
  end,
}
