zstyle ':completion:*' menu select

bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# fzf (interactive dependency layer)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh || source <(fzf --zsh)

bindkey -r '^R'
bindkey '^[r' fzf-history-widget
