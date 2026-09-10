return {
  { -- Split/join the treesitter node under the cursor (manual only)
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    keys = {
      { '<leader>cm', '<cmd>TSJToggle<cr>', desc = '[C]ode [M]ultiline toggle' },
      { '<leader>cs', '<cmd>TSJSplit<cr>', desc = '[C]ode [S]plit into lines' },
      { '<leader>cj', '<cmd>TSJJoin<cr>', desc = '[C]ode [J]oin into one line' },
    },
    opts = {
      -- Only ever act on the node under the cursor, via the keymaps above
      use_default_keymaps = false,
      -- Allow joining long blocks back up (default 120 refuses)
      max_join_length = 240,
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
