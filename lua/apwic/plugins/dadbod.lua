return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'dbout' },
      callback = function()
        vim.opt.foldenable = false
      end,
    })
  end,
  config = function()
    vim.keymap.set('n', '<leader>g', ':normal vip<CR><PLUG>(DBUI_ExecuteQuery)', { desc = '[G]o run query under the cursor' })
  end,
}
