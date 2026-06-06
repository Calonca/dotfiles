#!/usr/bin/env sh
# Installation logic. Settings live in config.sh — edit that, not this file.
#
# Installs dependencies (Fedora/dnf) and symlinks every file under the
# dotfiles dir to the matching path under $HOME. Safe to re-run: existing real
# files are backed up to <file>.bak and existing symlinks are replaced.
set -eu

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$REPO_DIR/config.sh"

# ---------------------------------------------------------------------------
# 1. Packages
# ---------------------------------------------------------------------------
if command -v dnf >/dev/null 2>&1; then
  if [ -n "${COPR_REPOS:-}" ]; then
    echo "==> Enabling COPR repos..."
    for repo in $COPR_REPOS; do
      echo "   enabling copr:$repo"
      sudo dnf copr enable -y "$repo"
    done
  fi
  echo "==> Installing packages with dnf..."
  sudo dnf install -y $PACKAGES
else
  echo "!! dnf not found. This installer targets Fedora." >&2
  echo "   Install these packages manually: $PACKAGES" >&2
fi

# ---------------------------------------------------------------------------
# 2. oh-my-zsh
# ---------------------------------------------------------------------------
if [ "${INSTALL_OH_MY_ZSH:-0}" = "1" ] && [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "==> Installing oh-my-zsh..."
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi

# ---------------------------------------------------------------------------
# 3. Symlink dotfiles
# ---------------------------------------------------------------------------
SRC_DIR="$REPO_DIR/$DOTFILES_DIR"
echo "==> Linking dotfiles from $DOTFILES_DIR/ into $HOME ..."
find "$SRC_DIR" \( -type f -o -type l \) | while IFS= read -r src; do
  rel="${src#"$SRC_DIR"/}"          # path relative to the dotfiles dir
  dst="$HOME/$rel"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "   backing up $dst -> $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -sfn "$src" "$dst"
  echo "   linked ~/$rel"
done

# ---------------------------------------------------------------------------
# 4. Default shell
# ---------------------------------------------------------------------------
ZSH_BIN="$(command -v zsh || true)"
if [ "${SET_DEFAULT_SHELL:-0}" = "1" ] && [ -n "$ZSH_BIN" ] \
   && [ "$(basename "${SHELL:-}")" != "zsh" ]; then
  echo "==> Setting zsh as the default shell (may prompt for your password)..."
  chsh -s "$ZSH_BIN" || echo "   could not chsh; run 'chsh -s $ZSH_BIN' manually"
fi

echo "==> Done. Restart your terminal or run: exec zsh"
