# Editable settings for install.sh. Change things here, not in the installer.
# This file is sourced by install.sh — it sets shell variables, no logic.

# COPR repos enabled (with `dnf copr enable`) before installing packages.
# Space-separated owner/project list. Needed for packages not in the main repos.
COPR_REPOS="lihaohong/yazi"

# Packages installed with dnf.
PACKAGES="git zsh neovim bat eza fzf zoxide btop tree yazi zsh-autosuggestions zsh-syntax-highlighting"

# Folder (relative to the repo root) whose contents mirror $HOME. Every file
# inside is symlinked to the matching path under $HOME, e.g.
#   dotfiles/.config/nvim/init.lua  ->  ~/.config/nvim/init.lua
DOTFILES_DIR="dotfiles"

# Clone oh-my-zsh into ~/.oh-my-zsh if missing (1 = yes, 0 = no).
INSTALL_OH_MY_ZSH=1

# Make zsh the default login shell (1 = yes, 0 = no).
SET_DEFAULT_SHELL=1
