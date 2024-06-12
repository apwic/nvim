return {
  'lervag/vimtex',
  lazy = false, -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.vimtex_view_method = 'sioyek'
    vim.g.vimtex_compiler_latexmk = {
      out_dir = 'output',
    }
  end,
  config = function()
    vim.cmd [[
      augroup vimtex
        autocmd!
        autocmd User VimtexEventViewReverse call b:vimtex.viewer.xdo_focus_vim()
      augroup END
    ]]
  end,
}
