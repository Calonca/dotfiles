bindkey "ç" fzf-cd-widget
bindkey '^T' fz:walkerf-file-widget
bindkey 'ß' fzf-completion

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments ($@) to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
  cd) fzf --preview 'tree -C {} | head -200' "$@" ;;
  export | unset) fzf --preview "eval 'echo \$'{}" "$@" ;;
  ssh) fzf --preview 'dig {}' "$@" ;;
  *) fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}

preview_content() {
  if [ -d "$1" ]; then
    # If it's a directory, show a colored tree view (up to 50 lines)
    tree -C "$1" | head -50
  elif [ -f "$1" ]; then
    # If it's a file, use bat to preview the first 50 lines
    bat --color=always --line-range :50 "$1"
  else
    echo "No preview available"
  fi
}

# completion preview
export function_content=$(declare -f preview_content)

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d "" cwd <"$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}
