# ~/.zshrc — managed by https://github.com/Calonca/dotfiles
# This file is symlinked from <repo>/dotfiles/.zshrc. Resolve the repo root from
# the real path of this file (works through the symlink) so repo-level helpers
# can be sourced regardless of where the repo was cloned.
REPO_ROOT="${${(%):-%x}:A:h:h}"

# ---------------------------------------------------------------------------
# Environment
# ---------------------------------------------------------------------------
export EDITOR="nvim"
export FILE_PREVIEW="bat --color=always --line-range :50 {}"
export FOLDER_PREVIEW="tree -C {} | head -50"
export TERM="xterm-256color"   # ghostty ssh fix
export _ZO_DOCTOR=0

# fzf configuration (mirrors the old home-manager setup)
export FZF_DEFAULT_OPTS="--height=99% --layout=reverse --border --info=inline"
export FZF_DEFAULT_COMMAND="find . -type f | sed 's|^\./||'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :50 {}'"
export FZF_ALT_C_COMMAND="find . -type d | sed 's|^\./||'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -50'"
export FZF_COMPLETION_TRIGGER="~~"
export FZF_COMPLETION_PATH_OPTS="--walker file,dir,follow,hidden"
export FZF_COMPLETION_DIR_OPTS=" --walker dir,follow"

# ---------------------------------------------------------------------------
# History
# ---------------------------------------------------------------------------
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS \
       HIST_FIND_NO_DUPS HIST_IGNORE_SPACE HIST_EXPIRE_DUPS_FIRST

# ---------------------------------------------------------------------------
# oh-my-zsh
# ---------------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=()
[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"

# ---------------------------------------------------------------------------
# Tool integrations
# ---------------------------------------------------------------------------
# fzf key bindings + completion
if command -v fzf >/dev/null 2>&1 && fzf --zsh >/dev/null 2>&1; then
  source <(fzf --zsh)
else
  [ -f /usr/share/fzf/shell/key-bindings.zsh ] && source /usr/share/fzf/shell/key-bindings.zsh
  [ -f /usr/share/fzf/shell/completion.zsh ]   && source /usr/share/fzf/shell/completion.zsh
fi

# zoxide
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# autosuggestions
[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ---------------------------------------------------------------------------
# Aliases & functions
# ---------------------------------------------------------------------------
alias ls='eza --icons=auto'
alias ll='eza -l --icons=auto'
alias la='eza -a --icons=auto'
alias lla='eza -la --icons=auto'
alias lt='eza --tree --icons=auto'
alias hello='echo hello'
alias cd='z'

# Pull the latest dotfiles and re-run the installer.
update() {
  ( cd "$REPO_ROOT" && git pull --ff-only && sh ./install.sh )
}

# Shared shell functions (yazi wrapper, fzf history widget, previews, ...)
source "$REPO_ROOT/additional_functions.sh"
if [ -f "$REPO_ROOT/user_specific/additional_functions.sh" ]; then
  source "$REPO_ROOT/user_specific/additional_functions.sh"
fi

# ---------------------------------------------------------------------------
# Syntax highlighting (must be sourced last)
# ---------------------------------------------------------------------------
[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
