eval "$(zoxide init zsh)"

command -v direnv >/dev/null && eval "$(direnv hook zsh)"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
command -v mise >/dev/null && eval "$(mise activate zsh)"
