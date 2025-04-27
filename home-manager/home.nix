{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "asaki";
  home.homeDirectory = "/home/asaki";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # add modules file path
  imports = [
    ./direnv.nix
    ./development.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./rofi.nix
    ./zed.nix
    ./zsh.nix
  ];

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    brave
    fastfetch # fetch system information
    discord
    omekasy # generate dressed up text
    teip # modern pipeline
    marp-cli
    textlint
    eza # modern ls command
    zoxide # smarter cd command
    wthrr # weather command
    zizmor # static analysis tool for GitHub Actions
    dust # du command alternative
    bat # cat command alternative
    fd # find command alternative
    duf # df command alternative
    procs # ps command alternative
    bottom # top command alternative
    ripgrep # grep command alternative
    navi # cheat sheet
    delta # diff command alternative
    hyperfine # benchmarking tool
    broot # tree command alternative
    tokei # count code
    grex # generate regex
    silicon # code image generator
    fzf # commandline fuzzy finder
    lazygit # git terminal UI
    yazi # terminal file manager
    tmux # terminal multiplexer
    ncspot # Cross-platform ncurses Spotify client
    valgrind # memory leak detector
    ctop # Top-like interface for container metrics
    oha # HTTP load generator inspired by rakyll/hey with tui animation
    lolcat # Rainbow version of cat
    termdown # Starts a countdown to or from TIMESPEC
    neo-cowsay # Cowsay reborn, written in Go
    gping # Ping, but with a graph
    sl # Steam Locomotive runs across your terminal when you type 'sl'
    obsidian
    anki
    zulip
    slack
    telegram-desktop
    spotify
    syncthing
    rquickshare # rust implementation of quickshare
    act # GitHub Actionsのローカル実行
    pinact # Pin GitHub Actions versions
    gobuster # Tool used to brute-force URIs and DNS subdomains.
    sniffnet # Cross-platform application to monitor your network traffic with ease
    atuin #Replacement for a shell history which records additional commanads
    charm-freeze # Tool to generate images of code and terminal output
    actionlint # Static checker for GitHub Actions workflow files
    # clive # Automates terminal operations
    genact # Nonsense activity generator
    vhs # Tool for generating terminal GIFs with code
    xh # Friendly and fast tool for sending HTTP requests
    wireshark # Powerful network protocol analyzer
    waybar # Highly customizable Wayland bar for Sway and Wlroots based compositors
    grimblast # Helper for screenshots within Hyprland, based on grimshot
    hyprpaper # Blazing fast wayland wallpaper utility
    dunst # Lightweight and customizable notification daemon
    wlogout # Wayland based logout menu
    cliphist # Wayland clipboard History
    wl-clipboard # Wayland clipboard manager
    zenity
    networkmanagerapplet # network manager gui
    brightnessctl # screen brightness


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
  #  /etc/profiles/per-user/asaki/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # GitHub CLI Settings
  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-markdown-preview
      gh-copilot
      gh-dash
      gh-poi
      gh-actions-cache
      # gh-skyline
      gh-eco
    ];
    settings = {
      editor = "vim";
      git_protocol = "ssh";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
