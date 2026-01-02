# Minimal Neovim Config

A minimal Neovim configuration with mouse support, clickable tabs, file explorer, and Doom Emacs-style keybindings.

## Features

- **Mouse Support**: Full mouse support with right-click context menu
- **Clickable Buffer Tabs**: Click to switch buffers, right-click to close
- **File Explorer**: NvimTree with mouse click actions
- **Telescope Fuzzy Finder**: Fast file and text search
- **Doom Emacs Keybindings**: Familiar SPC-based keybindings
- **Modern UI**: Tokyo Night theme with icons and statusline

Does not need `python`, `pynvim`, `lua`, `luarocks`, etc. installed on the host machine.

Telescope plugin can use `ripgrep` and `fd` when available (install on Windows with `choco`).

Test the setup with `:checkhealth`.

## Quick Install

### Windows

<https://chocolatey.org/install>

```bash
choco install neovim git ripgrep fd fzf
```

### Linux & MacOS

```bash
mkdir -p ~/.config/nvim && curl -fsSL https://raw.githubusercontent.com/gambhiro/neovim-config-minimal/main/init.lua -o ~/.config/nvim/init.lua && echo "Neovim config installed! Open nvim to auto-install plugins."
```

Or using `wget`:

```bash
mkdir -p ~/.config/nvim && wget -O ~/.config/nvim/init.lua https://raw.githubusercontent.com/gambhiro/neovim-config-minimal/main/init.lua && echo "Neovim config installed! Open nvim to auto-install plugins."
```

### Windows (PowerShell)

```powershell
New-Item -ItemType Directory -Force -Path "$env:LOCALAPPDATA\nvim" | Out-Null; Invoke-WebRequest -Uri "https://raw.githubusercontent.com/gambhiro/neovim-config-minimal/main/init.lua" -OutFile "$env:LOCALAPPDATA\nvim\init.lua"; Write-Host "Neovim config installed! Open nvim to auto-install plugins."
```

### Windows (Git Bash / WSL)

```bash
mkdir -p ~/AppData/Local/nvim && curl -fsSL https://raw.githubusercontent.com/gambhiro/neovim-config-minimal/main/init.lua -o ~/AppData/Local/nvim/init.lua && echo "Neovim config installed! Open nvim to auto-install plugins."
```

## Post-Installation

1. **Open Neovim**:
   ```bash
   nvim
   ```

2. **Wait for plugins to install** (1-2 minutes on first launch)

3. **Restart Neovim** to ensure everything loads properly

4. **(Optional) Install a Nerd Font** for icons:
   - Download from [Nerd Fonts](https://www.nerdfonts.com/)
   - Recommended: JetBrainsMono Nerd Font, FiraCode Nerd Font, or Hack Nerd Font

## Keybindings

### Doom Emacs Style (Leader = Space)

| Keybinding | Action |
|------------|--------|
| `SPC f f` | Find file |
| `SPC p f` | Find file in project |
| `SPC s s` | Search in current buffer |
| `SPC s p` | Search in project (live grep) |
| `SPC s d` | Search in directory |
| `SPC b b` | Switch buffer |
| `SPC b d` | Delete/kill buffer |

### Window Management

| Keybinding | Action |
|------------|--------|
| `SPC w w` | Switch to other window |
| `SPC w v` | Split vertical, stay in current |
| `SPC w V` | Split vertical, focus new window |
| `SPC w s` | Split horizontal, stay in current |
| `SPC w S` | Split horizontal, focus new window |
| `SPC w d` | Close current window |

### File Explorer

| Keybinding | Action |
|------------|--------|
| `Ctrl+n` | Toggle file explorer |
| `SPC e` | Focus file explorer |

### Buffer Navigation

| Keybinding | Action |
|------------|--------|
| `Shift+h` | Previous buffer |
| `Shift+l` | Next buffer |
| `SPC 1-9` | Jump to buffer 1-9 |

### Mouse Actions

- **Left-click buffer tab**: Switch to buffer
- **Right-click buffer tab**: Close buffer
- **Right-click selection**: Show copy menu
- **Click in file explorer**: Open file/folder

## Troubleshooting

### Plugins don't install automatically

Open Neovim and manually sync plugins:
```vim
:Lazy sync
```

### Check for issues

Run Neovim health check:
```vim
:checkhealth
```

### Icons not showing

Install a [Nerd Font](https://www.nerdfonts.com/) and set it in your terminal emulator.

### Config not found

Verify the config location:
- **Linux/MacOS**: `~/.config/nvim/init.lua`
- **Windows**: `%LOCALAPPDATA%\nvim\init.lua`

## Prerequisites

- **Neovim 0.9+** installed ([Installation guide](https://github.com/neovim/neovim/wiki/Installing-Neovim))
- **Git** installed (for plugin manager)
- **A terminal with true color support**
- **(Optional) ripgrep** for faster project search: `apt install ripgrep` / `brew install ripgrep` / `choco install ripgrep`

## Uninstall

### Linux & MacOS
```bash
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```

### Windows (PowerShell)
```powershell
Remove-Item -Recurse -Force "$env:LOCALAPPDATA\nvim", "$env:LOCALAPPDATA\nvim-data"
```

## Plugins Used

- [lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) - File explorer
- [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) - Buffer tabs
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - Statusline
- [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) - Color scheme

