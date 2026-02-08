return {
  { -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 3000,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters = {
        kulala = {
          command = 'kulala-fmt',
          args = { 'format', '$FILENAME' },
          stdin = false,
        },
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        python = { 'isort', 'black' },
        markdown = function(bufnr)
          -- Skip mdformat for Obsidian vaults
          local file_path = vim.api.nvim_buf_get_name(bufnr)
          local obsidian_ok, obsidian = pcall(require, 'obsidian')
          if obsidian_ok and obsidian.get_client then
            local client = obsidian.get_client()
            if client and client.dir then
              local vault_path = tostring(client.dir)
              if string.match(file_path, vim.pesc(vault_path)) then
                return {}
              end
            end
          end
          return { 'mdformat' }
        end,
        go = { 'gofmt' },
        json = { 'jq' },
        yaml = { 'yamlfmt' },
        http = { 'kulala' },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        -- javascript = { { "prettierd", "prettier" } },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
