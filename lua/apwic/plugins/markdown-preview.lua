return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  ft = { 'markdown' },
  build = 'cd app && yarn install',
  config = function()
    vim.g.mkdp_browserfunc = 'OpenMarkdownPreview'
    vim.cmd [[
      function! OpenMarkdownPreview(url)
        silent execute '!cmux browser open-split ' . shellescape(a:url)
      endfunction
    ]]

    vim.keymap.set('n', '<leader>po', '<cmd>MarkdownPreview<CR>', { desc = 'Markdown Preview Open' })
    vim.keymap.set('n', '<leader>pc', '<cmd>MarkdownPreviewStop<CR>', { desc = 'Markdown Preview Close' })
  end,
}
