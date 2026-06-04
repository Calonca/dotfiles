#!/usr/bin/env sh
# One-shot bootstrap for a fresh Fedora machine. Clones the dotfiles repo and
# runs the installer. Usage:
#
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/Calonca/dotfiles/main/bootstrap.sh)"
#
set -eu

REPO_URL="https://github.com/Calonca/dotfiles.git"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.config/dotfiles}"

if ! command -v git >/dev/null 2>&1; then
  echo "==> Installing git..."
  sudo dnf install -y git
fi

if [ -d "$DOTFILES_DIR/.git" ]; then
  echo "==> Updating existing clone in $DOTFILES_DIR..."
  git -C "$DOTFILES_DIR" pull --ff-only
else
  echo "==> Cloning $REPO_URL into $DOTFILES_DIR..."
  git clone "$REPO_URL" "$DOTFILES_DIR"
fi

sh "$DOTFILES_DIR/install.sh"
