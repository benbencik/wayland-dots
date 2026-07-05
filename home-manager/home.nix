{ config, pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "benb";
  home.homeDirectory = "/home/benb";
  home.enableNixpkgsReleaseCheck = false;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # User-specific packages
  # System-wide packages should go in /etc/nixos/configuration.nix
  home.packages = with pkgs; [
    # Development Tools
    nodejs
    python3
    gcc
    gnumake
    libclang
    autoconf
    valgrind
    lldb
    pkg-config
    devenv
    pnpm
    elan # somehow this is lean    

    # CLI Tools
    htop
    tree
    wget
    vim
    jq
    lsof
    eza
    bat
    fzf
    tldr
    ripgrep # better grep
    bottom # nice rust-based top
    gh # github cli tool

    gocryptfs
    pinentry-all
    
    # Shell
    spaceship-prompt
    starship
    
    # Media & Productivity
    yt-dlp
    termusic
    obs-studio
    gimp
    
    # File Management
    yazi
    pcmanfm
    ncdu # terminal disk space analyzer

    # Wayland Tools
    grim
    slurp
    wl-clipboard
    wallust
    conky
    hypridle
    
    # Audio
    playerctl
    wiremix
    pamixer
    
    # Browsers
    brave
    chromium
    tor-browser
    
    # Communication
    signal-desktop
    
    # Documents & Writing
    obsidian
    libreoffice
    pandoc
    typst
    typstyle
    
    # Time Tracking
    watson
    porsmo
    
    # Other
    linuxPackages.cpupower
    gemini-cli
    github-copilot-cli
    claude-code
    unzip
    yt-dlp
    nym
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink /home/benb/wayland-dots/hypr;
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink /home/benb/wayland-dots/waybar;
    ".config/mako".source = config.lib.file.mkOutOfStoreSymlink /home/benb/wayland-dots/mako;
    ".config/conky".source = config.lib.file.mkOutOfStoreSymlink /home/benb/wayland-dots/conky;
  };

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
  #  /etc/profiles/per-user/benb/etc/profile.d/hm-session-vars.sh
  #

  home.sessionVariables = {
    EDITOR = "vim";
    GTK_THEME = "Everforest-Dark-Medium";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # ============================================
  # Terminal
  # ============================================

  programs.kitty = {
    enable = true;
    themeFile = "Ayaka";
    settings = {
      editor = "vim";
      confirm_os_window_close = 0;
    };
  };

  # ============================================
  # Development Tools
  # ============================================

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
    config = {
      whitelist = {
        prefix = ["~/Code"];
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    initContent = ''
      # Re-trigger direnv when VSCode opens a terminal in a direnv-managed folder
      if [[ -f .envrc ]]; then
        eval "$(direnv export zsh)"
      fi

      # Sort completions by last modified (newest first)
      zstyle ':completion:*' file-sort modification
    '';

    oh-my-zsh = {
      enable = true;
      # theme = "spaceship";
      # custom = "${pkgs.spaceship-prompt}/share/zsh";
      plugins = [ "git" ];
    };

    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
    };

    shellAliases = {
      # Modern CLI replacements
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      cat = "bat";
      
      # NixOS management
      nix-conf = "sudo nano /etc/nixos/configuration.nix";
      nix-update = "sudo nixos-rebuild switch";
      nix-search = "nix search nixpkgs";
      hm-update = "home-manager switch";
      
      # Watson time tracking
      ws = "watson stop";
      we = "watson edit";
      wa = "watson aggregate | tail";
      wr = "watson restart";
      
      # Power management
      tlp-notebook = "sudo tlp fullcharge BAT0";
      tlp-desktop = "sudo tlp setcharge 30 80 BAT0";
      
      # Custom scripts
      duck = "~/.config/home-manager/hello-duck.sh";
    };

  };

  # ============================================
  # Version Control
  # ============================================

  programs.git = {
    enable = true;
    settings = {
      user.name = "benbencik";
      user.email = "bencik42@gmail.com";
      pull.rebase = true;
      color.ui = "auto";
      init.defaultBranch = "main";
    };
  };

  # ============================================
  # GTK Theme
  # ============================================

  gtk = {
    enable = true;
    theme = {
      name = "Everforest-Dark-Medium";
    };
    gtk4.theme = null;
  };
}
