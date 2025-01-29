return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup {
        use_icons = vim.g.have_nerd_font,
        section_filename = function()
          return ''
        end,
      }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- Remove the file path in status line
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_filename = function()
        return ''
      end

      -- Display file path in winbar
      -- Get the default colors of WinBar and WinBarNC
      local winbar_active = vim.api.nvim_get_hl(0, { name = 'WinBar' })
      local winbar_nc = vim.api.nvim_get_hl(0, { name = 'WinBarNC' })

      -- Swap their colors
      vim.api.nvim_set_hl(0, 'WinBar', { bg = winbar_nc.bg, fg = winbar_nc.fg, bold = winbar_nc.bold })
      vim.api.nvim_set_hl(0, 'WinBarNC', { bg = winbar_active.bg, fg = winbar_active.fg, bold = winbar_active.bold })

      vim.api.nvim_create_autocmd('BufEnter', {
        callback = function()
          local filepath = vim.fn.expand '%:p'
          local home = vim.fn.expand '$HOME'
          if filepath:find(home, 1, true) == 1 then
            filepath = filepath:gsub('^' .. vim.pesc(home), '~')
          end
          vim.wo.winbar = filepath
        end,
      })

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
