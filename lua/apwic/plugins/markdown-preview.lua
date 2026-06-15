return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  ft = { 'markdown' },
  build = 'cd app && yarn install',
  config = function()
    local scripts_dir = vim.fn.stdpath 'config' .. '/scripts'
    vim.g.mkdp_browserfunc = 'OpenMarkdownPreview'
    vim.cmd(string.format([[
      function! OpenMarkdownPreview(url)
        silent execute '!%s/cmux-browser-open ' . shellescape(a:url)
      endfunction
    ]], scripts_dir))

    vim.keymap.set('n', '<leader>po', '<cmd>MarkdownPreview<CR>', { desc = 'Markdown Preview Open' })
    vim.keymap.set('n', '<leader>pc', '<cmd>MarkdownPreviewStop<CR>', { desc = 'Markdown Preview Close' })
  end,
}
