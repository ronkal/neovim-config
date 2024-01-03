-----------------------------------------------------------
-- Neovim LSP configuration file
-----------------------------------------------------------

local M = {}

local servers = {
  "lua_ls",
  "bashls",
  "clangd",
  "cssls",
  "eslint",
  "html",
  "jsonls",
  "tsserver",
  "tailwindcss",
  "pyright",
}

-- TODO: Add a way to install also formatters, and linters alongside the plugins.
-- See https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
-- local formatters = {
--   "black",
-- }

M.mason = {
  "williamboman/mason.nvim",
  config = function()
    require('mason').setup {}
  end
}

M.mason_lspconfig = {
  'williamboman/mason-lspconfig.nvim',
  dependencies = {
    'williamboman/mason.nvim',
    'neovim/nvim-lspconfig',
  },
  config = function()
    require('mason-lspconfig').setup {
      ensure_installed = servers,
    }
  end
}

M.nvim_lspconfig = {
  'neovim/nvim-lspconfig',
  config = function()
    local lspconfig = require('lspconfig')
    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup {}
    end
  end
}

return M
