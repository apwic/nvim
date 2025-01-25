return {
  'theprimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup {}

    -- basic telescope configuration
    local conf = require('telescope.config').values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end
      require('telescope.pickers')
        .new({}, {
          prompt_title = 'Harpoon',
          finder = require('telescope.finders').new_table {
            results = file_paths,
          },
          previewer = conf.file_previewer {},
          sorter = conf.generic_sorter {},
        })
        :find()
    end

    vim.keymap.set('n', '<leader>he', function()
      toggle_telescope(harpoon:list())
    end, { desc = 'Open harpoon window' })
  end,
  keys = {
    {
      '<leader>hh',
      function()
        require('harpoon'):list():add()
      end,
      desc = 'harpoon file',
    },
    {
      '<leader>hf',
      function()
        local harpoon = require 'harpoon'
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = 'harpoon quick menu',
    },
    {
      '<leader>h1',
      function()
        require('harpoon'):list():select(1)
      end,
      desc = 'harpoon to file 1',
    },
    {
      '<leader>h2',
      function()
        require('harpoon'):list():select(2)
      end,
      desc = 'harpoon to file 2',
    },
    {
      '<leader>h3',
      function()
        require('harpoon'):list():select(3)
      end,
      desc = 'harpoon to file 3',
    },
    {
      '<leader>h4',
      function()
        require('harpoon'):list():select(4)
      end,
      desc = 'harpoon to file 4',
    },
    {
      '<leader>h5',
      function()
        require('harpoon'):list():select(5)
      end,
      desc = 'harpoon to file 5',
    },
  },
}
