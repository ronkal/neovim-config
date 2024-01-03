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
            -- { action = 'lua require("persistence").load()',                        desc = " Restore Session", icon = " ", key = "s" },
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
