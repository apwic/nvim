return {
  'sindrets/diffview.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose', 'ReviewOpen' },
  opts = {
    view = {
      default = {
        layout = 'diff2_horizontal', -- side-by-side diff for all workflows
      },
      merge_tool = {
        layout = 'diff3_vertical', -- for merge conflicts
      },
      file_history = {
        layout = 'diff2_vertical', -- stacked file history diff
      },
    },
    file_panel = {
      listing_style = 'tree',
      win_config = {
        position = 'left',
        width = 35,
      },
    },
    file_history_panel = {
      win_config = {
        position = 'bottom',
        height = 16,
      },
    },
  },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Diffview open' },
    { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'File history' },
    { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = 'Repo history' },
    { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = 'Diffview close' },
  },
  config = function(_, opts)
    local diffview = require 'diffview'
    diffview.setup(opts)

    vim.api.nvim_create_user_command('ReviewOpen', function(ctx)
      diffview.open(require('diffview.arg_parser').scan(ctx.args).args)
    end, {
      nargs = '*',
      complete = function(_, cmd_line, cur_pos)
        return diffview.completion(_, cmd_line:gsub('^ReviewOpen', 'DiffviewOpen'), cur_pos + 2)
      end,
    })
  end,
}
