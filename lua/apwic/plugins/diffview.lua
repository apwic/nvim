return {
  'sindrets/diffview.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
  opts = {
    view = {
      default = {
        layout = 'diff2_vertical', -- side-by-side diff
      },
      merge_tool = {
        layout = 'diff3_vertical', -- for merge conflicts
      },
      file_history = {
        layout = 'diff2_vertical', -- also for file history view
      },
    },
    file_panel = {
      listing_style = 'list',
      win_config = {
        position = 'bottom',
        height = 12,
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
}
