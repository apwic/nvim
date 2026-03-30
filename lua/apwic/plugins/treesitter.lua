return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    lazy = false,
    config = function()
      require('nvim-treesitter').setup()
      require('nvim-treesitter.install').prefer_git = true

      -- Enable treesitter highlighting per buffer
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
          if lang and pcall(vim.treesitter.language.inspect, lang) then
            vim.treesitter.start(args.buf, lang)
          end
        end,
      })

      -- Defer parser installation check so it doesn't block startup
      vim.defer_fn(function()
        local ensure_installed = {
          'bash',
          'c',
          'diff',
          'html',
          'css',
          'javascript',
          'typescript',
          'lua',
          'luadoc',
          'markdown',
          'vim',
          'vimdoc',
          'json',
          'go',
        }

        local installed = require('nvim-treesitter.config').get_installed()
        local to_install = vim.tbl_filter(function(lang)
          return not vim.list_contains(installed, lang)
        end, ensure_installed)

        if #to_install > 0 then
          require('nvim-treesitter').install(to_install)
        end
      end, 0)
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
