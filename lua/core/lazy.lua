-----------------------------------------------------------
-- Plugin manager configuration file
-----------------------------------------------------------

-- Plugin manager: lazy.nvim
-- URL: https://github.com/folke/lazy.nvim

-- For information about installed plugins see the README:
-- neovim-lua/README.md
-- https://github.com/brainfucksec/neovim-lua#readme

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- the colorscheme should be available when starting Neovim
  require('core/colors').onedark,
  require('core/colors').tokyonight,
  require('core/colors').rose_pine,

  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    keys = {
      { '<leader>e', '<cmd>Neotree toggle left<cr>', 'n',
      desc = 'Reveal file explorer',
      noremap = true,
      silent = true,
      },
      { '<leader>be', '<cmd>Neotree toggle buffers position=float<cr>', 'n',
      desc = 'Reveal open buffers',
      noremap = true,
      silent = true,
      },
    },
    config = function()
      require('neo-tree').setup({
        filesystem = {
          hijack_netrw_behavior = "open_current"
        }
      })
    end
  },

  -- Dashboard
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      local logo = [[
::::    ::::   ::::::::   ::::::::  ::::    :::
+:+:+: :+:+:+ :+:    :+: :+:    :+: :+:+:   :+:
+:+ +:+:+ +:+ +:+    +:+ +:+    +:+ :+:+:+  +:+
+#+  +:+  +#+ +#+    +:+ +#+    +:+ +#+ +:+ +#+
+#+       +#+ +#+    +#+ +#+    +#+ +#+  +#+#+#
#+#       #+# #+#    #+# #+#    #+# #+#   #+#+#
###       ###  ########   ########  ###    ####
      ]]
      logo = string.rep("\n", 8) .. logo .. "\n\n"

      local opts = {
        theme = "doom",
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = vim.split(logo, "\n"),
          -- stylua: ignore
          center = {
            { action = "Telescope find_files", desc = " Find file", icon = " ", key = "f" },
            { action = "ene | startinsert", desc = " New file",icon = " ", key = "n" },
            { action = "Telescope oldfiles", desc = " Recent files", icon = " ", key = "r" },
            { action = "Telescope live_grep", desc = " Find text", icon = " ", key = "g" },
            -- { action = [[lua require("lazyvim.util").telescope.config_files()()]], desc = " Config",          icon = " ", key = "c" },
            { action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
            { action = "Lazy", desc = " Lazy", icon = " ", key = "l" },
            { action = "qa", desc = " Quit", icon = " ", key = "q" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "🚀 Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardLoaded",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require('dashboard').setup(opts)
    end,
    dependencies = {{'nvim-tree/nvim-web-devicons'}}
  },

  -- Indent blankline
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
    main = "ibl",
  },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      local map = vim.keymap.set
      local actions = require('telescope.actions')
      local action_layout = require('telescope.actions.layout')

      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<C-d>"] = actions.delete_buffer + actions.move_to_top,
              ["<M-p>"] = action_layout.toggle_preview
            }
          }
        }
      }

      map('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
      map('n', '<leader>fg', builtin.live_grep, { desc = 'Find live' })
      map('n', '<leader>fb', builtin.buffers, { desc = 'Find buffer' })
--      map('n', '<leader>fh', builtin.find_files, { desc = '' })
    end
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      require("telescope").setup {
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
            }
        }
      }
      require("telescope").load_extension("ui-select")
    end
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
          'bash',
          'c',
          'cpp',
          'comment',
          'css',
          'git_rebase',
          'gitcommit',
          'gitignore',
          'html',
          'javascript',
          'json',
          'lua',
          'markdown',
          'markdown_inline',
          'python',
          'sql',
          'tsx',
          'typescript',
        },
        auto_install = true,
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },

  -- Lualine
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      }
    end
  },

  -- Bufferline
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('bufferline').setup {}
    end
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    config = function()
      require('which-key').setup {}
    end,
  },

  -- Session saving
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    config = function()
      require('persistence').setup {}
    end
  },

  -- Pairs
  {
    'echasnovski/mini.pairs',
    version = false, -- From Main, not Stable
    config = function()
      require('mini.pairs').setup {
        mappings = {
          ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
          ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
          ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },

          [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
          [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
          ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

          ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
          ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
          ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
        },
      }
    end
  },

  -- Trouble
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {}
  },

  -- To-do comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local map = vim.keymap.set

      map('n', '<leader>ft', '<cmd>TodoTelescope<cr>', { desc = 'Search to-do comments' })

      require('todo-comments').setup {}
    end
  },

  -- Gitsigns
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, {expr=true, desc = 'Go to next hunk'})

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, {expr=true, desc = 'Go to prev hunk'})

          -- Actions
          map('n', '<leader>hs', gs.stage_hunk, { desc = 'Stage hunk'})
          map('n', '<leader>hr', gs.reset_hunk, { desc = 'Reset hunk'})
          map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = 'Stage hunk' })
          map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = 'Reset hunk' })
          map('n', '<leader>hS', gs.stage_buffer, { desc = 'Stage buffer' })
          map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })
          map('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset buffer' })
          map('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview hunk' })
          map('n', '<leader>hb', function() gs.blame_line{full=true} end, { desc = 'Blame line' })
          map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'Toggle current line blame' })
          map('n', '<leader>hd', gs.diffthis, { desc = 'Git diff' })
          map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = 'Diff with prev commit' })
          map('n', '<leader>td', gs.toggle_deleted, { desc = 'Toggle deleted' })

          -- Text object
          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
      }
    end
  },

  -- Bufremove
  {
    'echasnovski/mini.bufremove',
    version = false,
    config = function()
      require('mini.bufremove').setup {}
    end
  },

  -- LSP/Mason
  require('lsp/lspconfig').mason,
  require('lsp/lspconfig').mason_lspconfig,
  require('lsp/lspconfig').nvim_lspconfig,
},

-- Lazy options
{
  performance = {
    rtp = {
      disabled_plugins = {
        "netrwPlugin"
      }
    }
  }
})
