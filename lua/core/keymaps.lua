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
map({'n', 'i'}, '<C-s>', '<cmd>w<cr>', { desc = 'Save the current buffer' })
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
map('i', 'kk', '<esc>')    -- Map Esc to kk
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
map('n', '<leader>bd', '<cmd>lua MiniBufremove.delete()<cr>', { desc = 'Delete buffer'} )

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
-- Miscellaneous
-----------------------------------------------------------
-- Reload configuration
map('n', '<leader>r', '<cmd>source %<cr>', { desc = 'Reload configuration' })

-- Close editor
-- map('n', '<leader>q', '<cmd>q<cr>', { desc = 'Close editor' })
map('n', '<leader>qq', '<cmd>q<cr>', { desc = 'Close editor' })
map('n', '<leader>qa', '<cmd>qa<cr>', { desc = 'Quit all' })
map('n', '<leader>Q', '<cmd>q!<cr>', { desc = 'Close without saving (:q!)' })
