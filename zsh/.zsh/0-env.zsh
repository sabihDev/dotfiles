export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$HOME/.bun/bin:$HOME/go/bin:$GOPATH/bin:$FLYCTL_INSTALL/bin:$PATH"

export NVM_DIR="$HOME/.config/nvm"
export GOPATH="$HOME/go"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export ZSH="$HOME/.oh-my-zsh"
export HISTFILE="$HOME/.zhistory"
export HISTSIZE=1000000
export SAVEHIST=1000000
export EDITOR="nvim"

# Source personal secrets (NOT tracked in dotfiles)
# Create ~/.config/secrets/env with your private exports
if [ -f ~/.config/secrets/env ]; then
  source ~/.config/secrets/env
fi
