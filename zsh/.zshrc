# ~/.zshrc
export ZSH_CONFIG="$HOME/.zsh"

for file in $ZSH_CONFIG/*.zsh; do
  source "$file"
done
. "$HOME/.deno/env"
export PATH="$HOME/.deno/bin:$PATH"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
