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
  init = function()
    -- the remote file handling part
    vim.api.nvim_create_autocmd('BufEnter', {
      group = vim.api.nvim_create_augroup('RemoteFileInit', { clear = true }),
      callback = function()
        local f = vim.fn.expand '%:p'
        for _, v in ipairs { 'dav', 'fetch', 'ftp', 'http', 'rcp', 'rsync', 'scp', 'sftp' } do
          local p = v .. '://'
          if f:sub(1, #p) == p then
            vim.cmd [[
              unlet g:loaded_netrw
              unlet g:loaded_netrwPlugin
              runtime! plugin/netrwPlugin.vim
              silent Explore %
            ]]
            break
          end
        end
        vim.api.nvim_clear_autocmds { group = 'RemoteFileInit' }
      end,
    })
    vim.api.nvim_create_autocmd('BufEnter', {
      group = vim.api.nvim_create_augroup('NeoTreeInit', { clear = true }),
      callback = function()
        local f = vim.fn.expand '%:p'
        if vim.fn.isdirectory(f) ~= 0 then
          vim.cmd('Neotree current dir=' .. f)
          vim.api.nvim_clear_autocmds { group = 'NeoTreeInit' }
        end
      end,
    })
    -- keymaps
  end,
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', { desc = 'NeoTree reveal' } },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
      filtered_items = {
        visible = true,
      },
      hijack_netrw_behavior = 'open_current',
    },
  },
}
