-- Disable netrw before nvim-tree setup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
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

-- Additional mouse behavior for built-in right-click menu
vim.opt.mousemodel = 'popup_setpos'  -- Right-click positions cursor and shows menu

-- Disable startup screen
vim.opt.shortmess:append('I')

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
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
        })
      end,
    },

    -- Status line
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require('lualine').setup()
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
            offsets = {
              {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "center",
                separator = true,
              }
            },
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

    -- Color scheme
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        vim.cmd([[colorscheme tokyonight-night]])
      end,
    },
  },

  -- Configure any other settings here.

  -- automatically check for plugin updates
  -- checker = { enabled = true },
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

print("Neovim config loaded successfully")
