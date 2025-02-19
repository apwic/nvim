return {
  {
    'schrieveslaach/sonarlint',
    url = 'https://gitlab.com/schrieveslaach/sonarlint.nvim',
    config = function()
      require('sonarlint').setup {
        server = {
          cmd = {
            'sonarlint-language-server',
            -- Ensure that sonarlint-language-server uses stdio channel
            '-stdio',
            '-analyzers',
            -- paths to the analyzers you need, using those for python and java in this example
            vim.fn.expand '$MASON/share/sonarlint-analyzers/sonargo.jar',
            -- vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarpython.jar',
            -- vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarcfamily.jar',
            -- vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarjava.jar',
          },
        },
        filetypes = {
          'go',
          -- 'python',
          -- 'cpp',
          -- 'java',
        },
      }
    end,
  },
}
