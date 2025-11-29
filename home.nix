
{ config, pkgs, username, homeDirectory, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  # TODO: Move to pc specific config file   
  home.username = username;
  home.homeDirectory = homeDirectory;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

   

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # imports = [
  #   ./user_specific/session_path.nix
  #   # other imports...7
  # ];

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/alessandro/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    # Folder commands
    FILE_PREVIEW = "bat --color=always --line-range :50 {}";
    FOLDER_PREVIEW = "tree -C {} | head -50";
    TERM = "xterm-256color"; # ghostty ssh fix
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bat.enable = true;

  programs.eza = {
      enable = true;
      enableZshIntegration = true;
      icons = "auto";
  };

  programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
      color_theme = "catppuccin_mocha"; 
    };
    themes = {
      catppuccin_mocha = builtins.readFile ./btop/themes/catppuccin_mocha.theme;
    };
  };
  
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    changeDirWidgetCommand = "find . -type d | sed 's|^\\./||'";
    changeDirWidgetOptions = [ "--preview 'tree -C {} | head -50'" ];
    defaultCommand = "find . -type f | sed 's|^\\./||'";
    defaultOptions = [ "--height=99%" "--layout=reverse" "--border" "--info=inline" ];
    fileWidgetCommand = "find . -type f | sed 's|^\\./||'";
    fileWidgetOptions = [ "--preview 'bat --color=always --line-range :50 {}'" ];
    tmux.enableShellIntegration = true;
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
    settings = {
        mgr = {
            linemode = "size";
          };
      };
  };


  programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      update = "cd ~/.config/nix && nix run .#homeConfigurations.${username}.activationPackage && cd -";
      # ls = "eza -a --icons auto";
      # ll = "eza -al --icons auto";
      # lt = "eza -a --tree --level=1 --icons auto";
      hello = "echo hello";
      cd = "z";
    }; 
    oh-my-zsh = { # "ohMyZsh" without Home Manager
      enable = true;
      # plugins = [ "fzf"];
      theme = "robbyrussell";
    };

    initContent = ''
    # Set FZF completion trigger after fzf initialization
    export FZF_COMPLETION_TRIGGER="~~"
    export ZF_COMPLETION_PATH_OPTS="--walker file,dir,follow,hidden"
    export FZF_COMPLETION_DIR_OPTS=" --walker dir,follow"
    
    source ~/.config/nix/additional_functions.sh
    if [ -f ~/.config/nix/user_specific/additional_functions.sh ]; then
      source ~/.config/nix/user_specific/additional_functions.sh
    fi
    '';

  };
  
}
