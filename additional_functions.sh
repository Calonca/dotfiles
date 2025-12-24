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

# From https://github.com/junegunn/fzf/discussions/3629
modified-fzf-history-widget() {
  local selected
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases no_bash_rematch 2> /dev/null
  # appends the current shell history buffer to the HISTFILE
  builtin fc -AI $HISTFILE
  # pushes entries from the $HISTFILE onto a stack and uses this history
  builtin fc -p $HISTFILE $HISTSIZE $SAVEHIST
  selected="$(builtin fc -rl 1 |
    awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); if (!seen[cmd]++) print $0 }' |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} ${FZF_DEFAULT_OPTS-} -n2..,.. --scheme=history --bind=ctrl-r:toggle-sort,ctrl-z:ignore ${FZF_CTRL_R_OPTS-} --query=${(qqq)LBUFFER} --multi" $(__fzfcmd))"
  local ret=$?
	if [[ -n $selected ]]; then
    if [[ "$selected" =~ ^[[:blank:]]*[[:digit:]]+ ]]; then
	  builtin fc -pa "$HISTFILE"
	  zle vi-fetch-history -n "$MATCH"
    else # selected is a custom query, not from history
      LBUFFER="$selected"
    fi
  fi
  # Read the history from the history file into the history list
  builtin fc -R $HISTFILE
  zle reset-prompt
  return $ret
}
zle -N modified-fzf-history-widget
bindkey "^R" modified-fzf-history-widget


export FZF_CTRL_R_OPTS="$(
	cat <<'FZF_FTW'
--bind "ctrl-d:execute-silent(zsh -ic 'builtin fc -p $HISTFILE $HISTSIZE $SAVEHIST; for i in {+1}; do ignore+=( \"${(b)history[$i]}\" );done;
	HISTORY_IGNORE=\"(${(j:|:)ignore})\";builtin fc -W $HISTFILE')+reload:builtin fc -p $HISTFILE $HISTSIZE $SAVEHIST; builtin fc -rl 1 |
	awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, \"\", cmd); if (!seen[cmd]++) print $0 }'"
--bind 'enter:accept-or-print-query'
--header 'enter select · ^d remove'
--prompt ' Global History > '
FZF_FTW
)"

# 'ZDOTDIR' is a Parameter used by the shell, it refers to the location of your 
# shell startup files (see 'man zshparam')
export HISTFILE="${ZDOTDIR:-$HOME}"/.zsh_history
