-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      { 'nvim-telescope/telescope-dap.nvim' },
      {
        'nvim-telescope/telescope-live-grep-args.nvim',
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = '^1.0.0',
      },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      local lga_actions = require 'telescope-live-grep-args.actions'
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        pickers = {
          colorscheme = {
            enable_preview = true,
          },
        },
        defaults = {
          mappings = {
            i = {
              ['<C-j>'] = 'results_scrolling_down',
              ['<C-k>'] = 'results_scrolling_up',
              ['<C-f>'] = 'to_fuzzy_refine',
            },
            n = {
              ['<C-j>'] = 'results_scrolling_down',
              ['<C-k>'] = 'results_scrolling_up',
            },
          },
          dynamic_preview_title = true,
          layout_strategy = 'vertical',
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          ['dap'] = {},
          ['live_grep_args'] = {
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            mappings = { -- extend mappings
              i = {
                ['<C-k>'] = lga_actions.quote_prompt(),
                ['<C-i>'] = lga_actions.quote_prompt { postfix = ' --iglob ' },
                -- freeze the current list and start a fuzzy search in the frozen list
                ['<C-f>'] = lga_actions.to_fuzzy_refine,
              },
            },
            -- ... also accepts theme settings, for example:
            -- theme = "dropdown", -- use dropdown theme
            -- theme = { }, -- use own theme spec
            -- layout_config = { mirror=true }, -- mirror preview pane
          },
        },
      }

      -- Telescope previewers attach Tree-sitter highlighting without setting
      -- the buffer filetype. Treesitter Context requires that filetype to
      -- calculate and render the selected result's parent scope.
      local telescope_context_augroup = vim.api.nvim_create_augroup('telescope_context', { clear = true })
      local function raise_telescope_context(bufnr)
        local preview_win = vim.fn.bufwinid(bufnr)
        if preview_win == -1 then
          return
        end

        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.w[win].treesitter_context or vim.w[win].treesitter_context_line_number then
            local config = vim.api.nvim_win_get_config(win)
            if config.relative == 'win' and config.win == preview_win and config.zindex ~= 60 then
              config.zindex = 60
              vim.api.nvim_win_set_config(win, config)
            end
          end
        end
      end

      vim.api.nvim_create_autocmd('User', {
        group = telescope_context_augroup,
        pattern = 'TelescopePreviewerLoaded',
        callback = function(args)
          local filetype = args.data and args.data.filetype
          if not filetype or filetype == '' then
            return
          end

          vim.bo[args.buf].filetype = filetype
          if not vim.b[args.buf].telescope_context_refresh then
            vim.b[args.buf].telescope_context_refresh = true
            vim.api.nvim_create_autocmd('WinScrolled', {
              group = telescope_context_augroup,
              buffer = args.buf,
              callback = function()
                vim.schedule(function()
                  raise_telescope_context(args.buf)
                end)
              end,
            })
          end

          vim.defer_fn(function()
            if not vim.api.nvim_buf_is_valid(args.buf) then
              return
            end

            vim.api.nvim_buf_call(args.buf, function()
              vim.api.nvim_exec_autocmds('WinScrolled', { modeline = false })
            end)
            vim.schedule(function()
              raise_telescope_context(args.buf)
            end)
          end, 20)
        end,
      })

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'dap')
      pcall(require('telescope').load_extension, 'live_grep_args')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sa', require('telescope').extensions.live_grep_args.live_grep_args, { desc = '[S]ind by Ripgrep [A]rgs' })

      -- Diagnostics Telescope
      vim.keymap.set('n', '<leader>sdd', builtin.diagnostics, { desc = '[S]earch by [D]iagnostics [D] All' })
      vim.keymap.set('n', '<leader>sde', function()
        builtin.diagnostics { severity = vim.diagnostic.severity.ERROR }
      end, { desc = '[S]earch [D]iagnostics [E]rror' })
      vim.keymap.set('n', '<leader>sdw', function()
        builtin.diagnostics { severity = vim.diagnostic.severity.WARN }
      end, { desc = '[S]earch [D]iagnostics [W]arn' })

      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>sb', require('telescope').extensions.dap.list_breakpoints, { desc = '[S]earch by [B]reakpoints' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
