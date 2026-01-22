{ config, pkgs, ... }:

{
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
    # System monitoring
    conky
    
    # Media tools
    yt-dlp
    termusic
    
    # File management
    yazi
    
    # Shell prompt
    spaceship-prompt

    typst
    typstyle  # formater for typst

    porsmo

    wiremix
    gemini-cli
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Wayland/Hyprland configurations
    # ".config/hypr".source = /home/benb/wayland-dots/hypr;
    # ".config/waybar".source = /home/benb/wayland-dots/waybar;
    # ".config/mako".source = /home/benb/wayland-dots/mako;
    
    # # Application configurations
    # ".config/conky".source = /home/benb/wayland-dots/conky;
    # ".config/obsidian".source = /home/benb/wayland-dots/obsidian;
    # ".config/vscode".source = /home/benb/wayland-dots/vscode;
    
    # # Theming scripts
    # ".config/theming".source = /home/benb/wayland-dots/theming;
    
    # # Wallpapers
    # ".config/wallpapers".source = /home/benb/wayland-dots/wallpapers;
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
    EDITOR = "nvim";
    GTK_THEME = "Everforest-Dark-Medium";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # ============================================
  # Development Tools
  # ============================================
  
  # programs.neovim = {
  #   enable = true;
  #   plugins = with pkgs.vimPlugins; [
  #     vim-markdown
  #   ];
  #   viAlias = true;
  #   vimAlias = true;
  # };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # ============================================
  # Shell Configuration
  # ============================================
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    initExtra = ''
      # Custom PATH
      export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.foundry/bin:$PATH"
    '';

    shellAliases = {
      # File operations
      ll = "ls -l";
      
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
      tlp-desktop = "sudo tlp setcharge 50 80 BAT0";
      
      # Custom scripts
      duck = "~/.config/home-manager/hello-duck.sh";
    };

    oh-my-zsh = {
      enable = true;
      theme = "spaceship";
      custom = "${pkgs.spaceship-prompt}/share/zsh";
      plugins = [ "git" ];
    };

    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
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
  };
}
