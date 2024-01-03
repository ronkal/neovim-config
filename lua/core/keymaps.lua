-----------------------------------------------------------
-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Change leader to <Space>
vim.g.mapleader = ' '

-----------------------------------------------------------
-- File saving
-----------------------------------------------------------
map({ 'n', 'i' }, '<C-s>', '<cmd>w<cr>', { desc = 'Save the current buffer' })
map('n', '<leader><C-s>', '<cmd>wa<cr>', { desc = 'Save all the buffers' })

-----------------------------------------------------------
-- Text editing
-----------------------------------------------------------
-- No copy deletes to system clipboard
-- If you want to cut, go into visual mode first
map('n', 'dd', '"_dd')
map('n', 'x', '"_x')

-----------------------------------------------------------
-- Highlighting
-----------------------------------------------------------
map('n', '<leader>hc', '<cmd>nohl<cr>', { desc = 'Clear highlighting' })

-----------------------------------------------------------
-- Movement
-----------------------------------------------------------
map('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Move to lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Move to upper window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })
map('n', '<leader>wk', '<C-w>t<C-w>K', { desc = 'Change vertical to horizontal' })
map('n', '<leader>wh', '<C-w>t<C-w>H', { desc = 'Change horizontal to vertical' })
map('i', 'kk', '<esc>') -- Map Esc to kk
map('n', '<S-h>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev buffer' })
map('n', '<S-l>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' })

-----------------------------------------------------------
-- Buffers
-----------------------------------------------------------
map('n', ']b', '<cmd>BufferLineMoveNext<cr>', { desc = 'Move buffer to the right' })
map('n', 'b[', '<cmd>BufferLineMovePrev<cr>', { desc = 'Move buffer to the left' })
map('n', '<leader>bp', '<cmd>BufferLineTogglePin<cr>', { desc = 'Toggle buffer pin' })
map('n', '<leader>bP', '<cmd>BufferLineGroupClose ungrouped<cr>', { desc = 'Delete non-pinned buffers' })
map('n', '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', { desc = 'Delete other buffers' })
map('n', '<leader>br', '<cmd>BufferLineCloseRight<cr>', { desc = 'Delete buffers to the right' })
map('n', '<leader>bl', '<cmd>BufferLineCloseLeft<cr>', { desc = 'Delete buffers to the left' })
map('n', '<leader>bd', '<cmd>lua MiniBufremove.delete()<cr>', { desc = 'Delete buffer' })

-----------------------------------------------------------
-- Configuration
-----------------------------------------------------------
map('n', 'trn', '<cmd>set relativenumber!<cr>', { desc = 'Toggle relative numbers' })
map('n', 'tn', '<cmd>set number!<cr>', { desc = 'Toggle line numbers' })

-----------------------------------------------------------
-- Terminal
-----------------------------------------------------------
map('n', '<C-/>', '<cmd>terminal<cr>', { desc = 'Open terminal' })

-----------------------------------------------------------
-- Lazy
-----------------------------------------------------------
map('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'Open Lazy' })

-----------------------------------------------------------
-- LSP
-----------------------------------------------------------
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- FIX: Change this or explorer's keymap not to collide with each other
-- map('n', '<space>e', vim.diagnostic.open_float, { desc = 'Open diagnostics' })
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to prev diagnostic' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
map({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, { desc = 'Code actions' })
map('n', 'K', vim.lsp.buf.hover, { desc = 'Hover' })
map('n', '<space>f', function()
  vim.lsp.buf.format { async = true }
end, { desc = 'Format code'})
map('n', '<space>rn', vim.lsp.buf.rename, { desc = 'Global rename'})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    map('n', 'gD', vim.lsp.buf.declaration, opts)
    map('n', 'gd', vim.lsp.buf.definition, opts)
    map('n', 'gi', vim.lsp.buf.implementation, opts)

    -- FIX: Conflicting keymap
    -- map('n', '<C-k>', vim.lsp.buf.signature_help, opts)

    -- map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    -- map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    -- map('n', '<space>wl', function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, opts)
    map('n', '<space>D', vim.lsp.buf.type_definition, opts)
    map('n', 'gr', vim.lsp.buf.references, opts)
  end,
})
-----------------------------------------------------------
-- Miscellaneous
-----------------------------------------------------------
-- Reload configuration
map('n', '<leader>r', '<cmd>source %<cr>', { desc = 'Reload configuration' })

-- Close editor
-- map('n', '<leader>q', '<cmd>q<cr>', { desc = 'Close editor' })
map('n', '<leader>qq', '<cmd>q<cr>', { desc = 'Close editor' })
map('n', '<leader>qa', '<cmd>qa<cr>', { desc = 'Quit all' })
map('n', '<leader>Q', '<cmd>q!<cr>', { desc = 'Close without saving (:q!)' })
