return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        json = { 'jsonlint' },
        jsonc = { 'jsonlint' },
        -- markdown = { 'vale' },
        -- text = { 'vale' },
        -- rst = { 'vale' },
        go = { 'golangcilint' },
        yaml = { 'yamllint' },
      }

      -- Keep editor feedback quick; full linting still runs from the CLI and
      -- pre-commit hooks.
      --
      -- nvim-lint builds golangcilint.args by shelling out to `golangci-lint version`
      -- as its module loads. When the binary is missing that call raises E902, the
      -- plugin's pcall swallows it, and args comes back nil -- so the table.insert
      -- below would take this entire config block down with it, disabling json and
      -- yaml linting too. Guard it: no binary just means no Go linting.
      local golangcilint = require 'lint.linters.golangcilint'
      if type(golangcilint.args) == 'table' then
        table.insert(golangcilint.args, 2, '--fast-only')
        table.insert(golangcilint.args, 2, '--allow-serial-runners')
        lint.linters.golangcilint = golangcilint
      else
        lint.linters_by_ft.go = nil
        vim.schedule(function()
          vim.notify('nvim-lint: golangci-lint not found, Go linting disabled', vim.log.levels.WARN)
        end)
      end

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function(args)
          -- Only lint buffers backed by a real file. Diffview's buffers are named
          -- `diffview://…/:0:/path`, which linters resolve against cwd and fail on --
          -- golangci-lint logs a typechecking error and exits 7 (ErrorWasLogged).
          if not vim.uri_from_bufnr(args.buf):match('^file://') or vim.bo[args.buf].buftype ~= '' then
            return
          end

          -- golangci-lint is too expensive to run every time insert mode ends.
          if vim.bo.filetype == 'go' and args.event == 'InsertLeave' then
            return
          end

          local cwd = vim.fs.root(0, { '.git', 'go.work', 'go.mod' }) or vim.fn.getcwd()
          require('lint').try_lint(nil, { cwd = cwd })
        end,
      })

      -- Show linters for the current buffer's file type
      vim.api.nvim_create_user_command('LintInfo', function()
        local filetype = vim.bo.filetype
        local linters = require('lint').linters_by_ft[filetype]

        if linters then
          print('Linters for ' .. filetype .. ': ' .. table.concat(linters, ', '))
        else
          print('No linters configured for filetype: ' .. filetype)
        end
      end, {})
    end,
  },
}
