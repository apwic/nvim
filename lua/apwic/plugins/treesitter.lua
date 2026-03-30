return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup()

      -- Prefer git instead of curl in order to improve connectivity in some environments
      require('nvim-treesitter.install').prefer_git = true

      -- Ensure parsers are installed (new API replaces old ensure_installed)
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

      -- Enable treesitter highlighting and auto-install missing parsers
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          local lang = vim.treesitter.language.get_lang(ft)
          if lang then
            if pcall(vim.treesitter.language.inspect, lang) then
              vim.treesitter.start(args.buf, lang)
            else
              pcall(require('nvim-treesitter').install, { lang })
            end
          end
        end,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
