return {
  'OXY2DEV/markview.nvim',
  lazy = false,
  config = {
    preview = {
      enable = false,
    },
  },
  init = function()
    vim.keymap.set('n', '<leader>m', '<CMD>Markview<CR>', { desc = 'Toggle Markview' })
  end,
}
