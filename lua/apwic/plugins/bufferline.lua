return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require('bufferline').setup {
      options = {
        mode = 'tabs',
        always_show_bufferline = false,
        show_close_icon = false,
        show_buffer_close_icons = false,
      },
    }
  end,
}
