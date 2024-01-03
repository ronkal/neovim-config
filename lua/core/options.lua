-----------------------------------------------------------
-- General Neovim settings and configuration
-----------------------------------------------------------

-- Default options are not included
-- See: https://neovim.io/doc/user/vim_diff.html
-- [2] Defaults - *nvim-defaults*

local g = vim.g         -- Global variables
local opt = vim.opt     -- Set options (global/buffer/windows-scoped)

-----------------------------------------------------------
-- General
-----------------------------------------------------------
opt.mouse = 'a'                                 -- Enable mouse support
opt.clipboard = 'unnamedplus'                   -- Copy/paste to system clipboard
opt.swapfile = false                            -- Don't use swapfile
opt.completeopt = 'menuone,noinsert,noselect'   -- Autocomplete options
-- Modify update times
--  See `:help updatetime` and `:help timeoutlen`
opt.updatetime = 250
opt.timeoutlen = 300
opt.undofile = true                             -- Save undo history
-- opt.spell = true                                -- Activate spell-checking
-- opt.spelllang = { "en" }

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
opt.number = true           -- Show line number
opt.showmatch = true        -- Highlight matching parenthesis
opt.foldmethod = 'marker'   -- Enable folding (default 'foldmarker')
opt.colorcolumn = '90'      -- Line length marker at 80 columns
opt.splitright = true       -- Vertical split to the right
opt.splitbelow = true       -- Horizontal split to the bottom
opt.ignorecase = true       -- Ignore case letters when search
opt.smartcase = true        -- Ignore lowercase for the whole pattern
opt.linebreak = true        -- Wrap on word boundary
opt.termguicolors = true    -- Enable 24-bit RGB colors
opt.laststatus = 3          -- Set global statusline
opt.signcolumn = 'yes'      -- Set signcolumn
opt.hlsearch = false        -- Disables hlsearch
opt.fillchars:append('eob: ') -- Disables ~ at end of buffer
opt.showmode = false        -- Don't show mode since we have a status line

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.expandtab = true    -- Use spaces instead of tabs
opt.shiftwidth = 4      -- Shift 4 spaces when tab
opt.tabstop = 4         -- 1 tab == 4 spaces
opt.smartindent = true  -- Autoindent new lines
opt.breakindent = true  -- See `:help breakindent`
opt.shiftround = true   -- Round indent to multiple of 'shiftwidth'

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.hidden = true       -- Enable background buffers
opt.history = 100       -- Remember N lines in history
opt.lazyredraw = true   -- Faster scrolling
opt.updatetime = 250    -- ms to wait for trigger an event

-----------------------------------------------------------
-- Startup
-----------------------------------------------------------
-- Disable nvim intro
-- opt.shortmess:append "sI"    -- See `:help shortmess`
