return {
  {
    'tpope/vim-fugitive',
  },
  {
    'jecaro/fugitive-difftool.nvim',
    config = function()
      -- -- Jump to the first quickfix entry
      -- vim.api.nvim_create_user_command('Gcfir', require('fugitive-difftool').git_cfir, {})
      -- -- To the last
      -- vim.api.nvim_create_user_command('Gcla', require('fugitive-difftool').git_cla, {})

      local difftool = require 'fugitive-difftool'

      vim.keymap.set('n', '<leader>gcc', difftool.git_cc, { desc = '[G]itdifftool to the currently selected' })
      vim.keymap.set('n', '<leader>gcn', difftool.git_cn, { desc = '[G]itdifftool to the next' })
      vim.keymap.set('n', '<leader>gcp', difftool.git_cp, { desc = '[G]itdifftool to the previous' })

      vim.api.nvim_create_user_command('Gdifftool', function(opts)
        local args = opts.args
        if args == '' then
          print 'Usage: GDiffNames <main> <to-compare>'
          return
        end
        vim.cmd('G! difftool --name-status ' .. args)
      end, {
        nargs = '+',
        complete = function(_, line)
          local branches = vim.fn.systemlist "git branch --format='%(refname:short)'"
          return vim.tbl_filter(function(branch)
            return vim.startswith(branch, line:match '%S*$' or '')
          end, branches)
        end,
      })
    end,
  },
}
