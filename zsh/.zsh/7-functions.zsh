s() {
  fzf --ansi --disabled \
    --bind "change:reload:rg --line-number --no-heading --color=always --smart-case {q} || :" \
    --bind "enter:execute(nvim +{2} {1})" \
    --delimiter ":" \
    --preview "bat -p --color=always {1} --highlight-line {2}" \
    --preview-window 'up:80%,border-bottom,~3,+{2}+3/3'
}

c() {
  cd "$(zoxide query -l | fzf --height 40% --reverse --border --prompt='Dir> ')"
}

run() {
  [[ -z $1 ]] && { echo "Usage: run <file>"; return 1; }
  case ${1##*.} in
    c)    gcc "$1" -o "${1%.*}" && ./"${1%.*}" ;;
    py)   python3 "$1" ;;
    go)   go run "$1" ;;
    js)   node "$1" ;;
    ts)   npx ts-node "$1" ;;
    java) javac "$1" && java "${1%.*}" ;;
    *)    echo "Unsupported: ${1##*.}" ;;
  esac
}

yazi_cd() {
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  command yazi "$@" --cwd-file="$tmp"
  cwd="$(cat -- "$tmp")"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && cd -- "$cwd"
  rm -f -- "$tmp"
}

alias yazi='yazi_cd'
