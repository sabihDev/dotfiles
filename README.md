# Dotfiles

Personal development environment for **Ubuntu Linux** — minimal, fast, and developer-focused.

![Platform](https://img.shields.io/badge/platform-ubuntu%20linux-orange?style=for-the-badge&logo=ubuntu)
![Zsh](https://img.shields.io/badge/shell-zsh-blue?style=for-the-badge&logo=zsh)
![Neovim](https://img.shields.io/badge/editor-neovim%200.12-green?style=for-the-badge&logo=neovim)
![Tmux](https://img.shields.io/badge/multiplexer-tmux-cyan?style=for-the-badge)
![Ghostty](https://img.shields.io/badge/terminal-ghostty-magenta?style=for-the-badge)
![Starship](https://img.shields.io/badge/prompt-starship-yellow?style=for-the-badge&logo=starship)
![License](https://img.shields.io/badge/license-MIT-lightgrey?style=for-the-badge)

## Overview

A curated set of configuration files for a cohesive terminal-based development workflow. Managed with [GNU Stow](https://www.gnu.org/software/stow/) for clean symlink-based installation.

## Components

| Component | Description |
|-----------|-------------|
| **Ghostty** | GPU-accelerated terminal with Ayu Mirage theme, transparency, and blur |
| **Neovim** | Modern editor config using native `vim.pack` (no plugin manager) |
| **Starship** | Catppuccin Mocha prompt with language/runtime detection |
| **Tmux** | Terminal multiplexer with prefix `C-Space`, vi-mode, sessionizer |
| **Zsh** | Modular shell config with Oh My Zsh, zoxide, fzf, direnv, mise |

## Prerequisites

```bash
sudo apt install -y git curl wget stow ripgrep bat eza fzf zoxide fontconfig
```

Install the required tools:

| Tool | Installation |
|------|-------------|
| [Ghostty](https://ghostty.org) | `curl -sSf https://ghostty.org/install.sh \| sh` |
| [Neovim 0.12+](https://github.com/neovim/neovim) | Download from GitHub releases |
| [Starship](https://starship.rs) | `curl -sS https://starship.rs/install.sh \| sh` |
| [Tmux](https://github.com/tmux/tmux) | `sudo apt install tmux` |
| [Zsh](https://zsh.sourceforge.io) | `sudo apt install zsh && chsh -s $(which zsh)` |
| [Oh My Zsh](https://ohmyz.sh) | `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"` |

### Zsh Plugins

```bash
plugins_dir=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions       $plugins_dir/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting   $plugins_dir/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search $plugins_dir/zsh-history-substring-search
```

### Fonts

Requires a [Nerd Font](https://www.nerdfonts.com/) for icons. JetBrainsMono Nerd Font recommended:

```bash
mkdir -p ~/.local/share/fonts
wget -qO- https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz | tar -xJ -C ~/.local/share/fonts
fc-cache -fv
```

## Installation

```bash
git clone https://github.com/sabihDev/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow ghostty nvim tmux zsh starship
```

| Stow target | Symlink destination |
|-------------|-------------------|
| `ghostty` | `~/.config/ghostty/config` |
| `nvim` | `~/.config/nvim/` |
| `tmux` | `~/.tmux.conf` |
| `zsh` | `~/.zshrc`, `~/.zsh/` |
| `starship` | `~/.config/starship/starship.toml` |

To remove a symlink: `stow -D <target>`

## Directory Structure

```
dotfiles/
├── ghostty/
│   └── .config/ghostty/
│       └── config
├── nvim/
│   └── .config/nvim/
│       ├── init.lua
│       ├── lua/
│       │   ├── options.lua
│       │   ├── keymaps.lua
│       │   ├── commands.lua
│       │   ├── pack.lua
│       │   ├── treesitter.lua
│       │   ├── lsp.lua
│       │   ├── colors.lua
│       │   ├── statusline.lua
│       │   └── transparency.lua
│       └── nvim-pack-lock.json
├── tmux/
│   └── .tmux.conf
├── zsh/
│   ├── .zshrc
│   └── .zsh/
│       ├── 0-env.zsh
│       ├── 1-options.zsh
│       ├── 2-history-completion.zsh
│       ├── 3-plugins.zsh
│       ├── 4-prompt.zsh
│       ├── 5-tools.zsh
│       ├── 6-aliases.zsh
│       ├── 7-functions.zsh
│       └── 8-misc.zsh
├── starship/
│   └── .config/starship/
│       └── starship.toml
├── screenshots/
│   ├── ghostty.png
│   ├── neovim.png
│   └── tmux.png
└── README.md
```

## License

MIT
