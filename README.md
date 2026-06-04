# dotfiles

Plain-shell dotfiles + dependency installer for Fedora. No Nix.

## Fresh machine (one command)

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Calonca/dotfiles/main/bootstrap.sh)"
```

Clones the repo to `~/.config/dotfiles`, then runs `install.sh`.

## Already cloned

```bash
git clone https://github.com/Calonca/dotfiles.git ~/.config/dotfiles
cd ~/.config/dotfiles
sh install.sh
```

## Layout

| File / dir          | Purpose                                                        |
| ------------------- | -------------------------------------------------------------- |
| `config.sh`         | **Editable settings**: package list, toggles. No logic.        |
| `install.sh`        | Installation logic. Sources `config.sh`. Don't put settings here. |
| `bootstrap.sh`      | Clone-and-install one-liner for a fresh machine.               |
| `dotfiles/`         | Mirror of `$HOME`. Each file is symlinked to the same path.    |
| `additional_functions.sh` | Shared zsh functions, sourced by `.zshrc`.               |
| `user_specific/`    | Per-machine zsh functions (git-ignored).                       |

## How dotfiles are linked

`install.sh` walks `dotfiles/` and symlinks every file to the matching path
under `$HOME`. To add a dotfile, just drop it in the tree at its home-relative
path — no script change needed:

```
dotfiles/.config/nvim/init.lua   ->  ~/.config/nvim/init.lua
dotfiles/.zshrc                  ->  ~/.zshrc
```

Existing real files are backed up to `<file>.bak`; existing symlinks are
replaced. The installer is safe to re-run.

## Changing what gets installed

Edit `config.sh`:

- `PACKAGES` — the dnf package list.
- `DOTFILES_DIR` — the folder mirrored into `$HOME` (default `dotfiles`).
- `INSTALL_OH_MY_ZSH`, `SET_DEFAULT_SHELL` — toggles (`1`/`0`).

## Updating

Because the dotfiles are symlinked, `git pull` updates your live config. The
`update` shell function does both:

```bash
update   # git pull --ff-only && sh install.sh
```

## Per-machine functions

Put machine-specific shell functions in
`user_specific/additional_functions.sh` (git-ignored); `.zshrc` sources it if
present. See `user_specific/additional_functions.sh.template`.
