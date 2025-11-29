# Installation

0. Clone this repo
```bash
git clone https://github.com/Calonca/dotfiles.git ~/.config/nix/
```

1. Install Nix

2. Run 
```bash
nix run .#homeConfigurations.${USER}.activationPackage
```
```

Where USER is your username,
After this you can use the update command

3. Create the file
```
~/.config/nix/user_specific/additional_functions.sh
```

for custom functions
