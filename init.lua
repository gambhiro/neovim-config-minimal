-- init.lua - Basic Neovim configuration with mouse support, tabs, and file explorer

-- Leader key must be set BEFORE any keymaps
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable unused providers (prevents errors if not installed)
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Basic settings
vim.opt.mouse = 'a'  -- Enable mouse support
vim.opt.number = true  -- Show line numbers
vim.opt.relativenumber = true  -- Relative line numbers
vim.opt.termguicolors = true  -- True color support
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Disable startup screen
vim.opt.shortmess:append('I')

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Disable netrw before nvim-tree setup (strongly recommended)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Plugin specifications
require("lazy").setup({
  -- File explorer with mouse support
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      -- Disable netrw at the very start
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        view = {
          width = 30,
        },
        renderer = {
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },
        actions = {
          open_file = {
            quit_on_open = false,
          },
        },
        -- Disable system_open to prevent the E475 error
        system_open = {
          cmd = nil,
        },
        -- Fix for the 'q' key error
        on_attach = function(bufnr)
          local api = require('nvim-tree.api')

          local function opts(desc)
            return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          -- Default mappings
          api.config.mappings.default_on_attach(bufnr)

          -- Override 'q' to properly close
          vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
        end,
      })
    end,
  },

  -- Buffer line (clickable tabs)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          numbers = "ordinal",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          middle_mouse_command = nil,
          indicator = {
            style = 'icon',
            icon = '▎',
          },
          buffer_close_icon = '󰅖',
          modified_icon = '●',
          close_icon = '',
          left_trunc_marker = '',
          right_trunc_marker = '',
          diagnostics = "nvim_lsp",
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              separator = true,
            }
          },
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          separator_style = "thin",
        }
      })
    end,
  },

  -- Telescope fuzzy finder (for Doom-style search commands)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require('telescope').setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
      })
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'auto',
          section_separators = '',
          component_separators = '|'
        }
      })
    end,
  },

  -- Color scheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },
})

-- Key mappings (Doom Emacs style)
local keymap = vim.keymap

-- SPC f f - Find file (like Doom's file finder)
keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true, silent = true })

-- SPC p f - Find file in project
keymap.set('n', '<leader>pf', ':Telescope find_files<CR>', { noremap = true, silent = true })

-- SPC s s - Search in current buffer
keymap.set('n', '<leader>ss', ':Telescope current_buffer_fuzzy_find<CR>', { noremap = true, silent = true })

-- SPC s p - Search in project (live grep)
keymap.set('n', '<leader>sp', ':Telescope live_grep<CR>', { noremap = true, silent = true })

-- SPC s d - Search in directory
keymap.set('n', '<leader>sd', ':Telescope live_grep<CR>', { noremap = true, silent = true })

-- SPC b b - Switch buffer
keymap.set('n', '<leader>bb', ':Telescope buffers<CR>', { noremap = true, silent = true })

-- SPC b d - Delete/kill buffer
keymap.set('n', '<leader>bd', ':bdelete<CR>', { noremap = true, silent = true })

-- SPC t m - Toggle mouse support (allows terminal selection when disabled)
keymap.set('n', '<leader>tm', function()
  local current_mouse = vim.o.mouse
  if current_mouse == 'a' then
    vim.o.mouse = ''
    print('Mouse support disabled - terminal selection enabled')
  else
    vim.o.mouse = 'a'
    print('Mouse support enabled')
  end
end, { noremap = true, silent = false, desc = 'Toggle mouse support' })

-- Toggle file explorer
keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
keymap.set('n', '<leader>e', ':NvimTreeFocus<CR>', { noremap = true, silent = true })

-- Buffer navigation with bufferline
keymap.set('n', '<S-l>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
keymap.set('n', '<S-h>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })

-- Quick buffer switching
for i = 1, 9 do
  keymap.set('n', '<leader>' .. i, ':BufferLineGoToBuffer ' .. i .. '<CR>', { noremap = true, silent = true })
end

-- Additional mouse behavior for built-in right-click menu
vim.opt.mousemodel = 'popup_setpos'  -- Right-click positions cursor and shows menu

-- Auto commands
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    vim.opt.formatoptions:remove({ 'c', 'r', 'o' })
  end,
})

print("Neovim configuration loaded successfully!")
