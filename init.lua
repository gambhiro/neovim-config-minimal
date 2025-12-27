-- init.lua - Basic Neovim configuration with mouse support, tabs, and file explorer

-- Basic settings
vim.opt.mouse = 'a'  -- Enable mouse support
vim.opt.number = true  -- Show line numbers
vim.opt.relativenumber = true  -- Relative line numbers
vim.opt.termguicolors = true  -- True color support
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

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

-- Plugin specifications
require("lazy").setup({
  -- File explorer with mouse support
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
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

-- Enable right-click context menu
vim.cmd([[
  aunmenu PopUp
  vnoremenu PopUp.Copy "+y
  vnoremenu PopUp.Cut "+d
  nnoremenu PopUp.Paste "+p
  vnoremenu PopUp.Paste "+p
  vnoremenu PopUp.Select\ All ggVG
]])

-- Additional mouse behavior
vim.opt.mousemodel = 'popup_setpos'  -- Right-click positions cursor and shows menu

-- Auto commands
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    vim.opt.formatoptions:remove({ 'c', 'r', 'o' })
  end,
})

-- Leader key
vim.g.mapleader = ' '

print("Neovim configuration loaded successfully!")
