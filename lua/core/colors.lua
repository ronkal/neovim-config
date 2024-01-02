local M = {}

M.onedark = {
  'navarasu/onedark.nvim',
  lazy = true,
  config = function()
    require('onedark').setup {
      style = 'cool'
    }
  end
}

M.tokyonight = {
  "folke/tokyonight.nvim",
  lazy = true, -- make sure we load this during startup if it is your main colorscheme
  -- priority = 1000, -- make sure to load this before all the other start plugins
  -- config = function()
  --   -- load the colorscheme here
  --   vim.cmd([[colorscheme tokyonight]])
  -- end,
}

M.rose_pine = {
  'rose-pine/neovim',
  name = 'rose-pine',
  lazy = false,
  priority = 1000,
  config = function()
    require('rose-pine').setup {
      --- @usage 'auto'|'main'|'moon'|'dawn'
      variant = 'auto',
      --- @usage 'main'|'moon'|'dawn'
      dark_variant = 'moon'
    }
  end
}

return M
