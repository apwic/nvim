return {
  'toppair/peek.nvim',
  event = { 'VeryLazy' },
  build = 'deno task --quiet build:fast',
  config = function()
    require('peek').setup {
      app = 'browser', -- 'webview', 'browser', string or a table of strings
    }
    vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
    vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})
    
    -- Keybind for opening peek preview
    vim.keymap.set('n', '<leader>po', require('peek').open, { desc = 'Peek Open' })
  end,
}
