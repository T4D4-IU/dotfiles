{pkgs, ...}: {
  # Nix-darwin configuration entry point for MacBook

  # macOS GUI Apps managed by Nix (not available via Homebrew Cask)
  environment.systemPackages = [
    (pkgs.callPackage ./english-paper.nix {})
    (pkgs.callPackage ./escrcpy.nix {})
  ];

  system = {
    primaryUser = "t4d4";

    # System state version
    stateVersion = 5;

    # Japanese Localization
    defaults = {
      CustomUserPreferences."com.apple.GlobalDomain" = {
        AppleLanguages = ["ja-JP" "en-US"];
        AppleLocale = "ja_JP";
      };

      # Keyboard & Trackpad settings
      NSGlobalDomain = {
        InitialKeyRepeat = 15; # Fast repeat delay
        KeyRepeat = 2; # Fast repeat rate
        "com.apple.keyboard.fnState" = true; # Use F1, F2 etc. as standard function keys
      };
    };
  };

  # Disable nix-darwin's management of the Nix installation
  # since we are using Determinate Nix.
  nix.enable = false;

  # Homebrew for GUI Apps and System-level tools
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "uninstall"; # Use standard cleanup to avoid aggressively zapping unmanaged packages
    taps = [
      "Sikarugir-App/sikarugir"
    ];
    brews = [
      "cliclick"
    ];
    casks = [
      "android-commandlinetools"
      "android-studio"
      "anki"
      "antigravity"
      "appcleaner"
      "background-music"
      "bluestacks"
      "brave-browser"
      "clipaste"
      "discord"
      "ghostty"
      "google-chrome"
      "google-drive"
      "google-gemini"
      "google-japanese-ime"
      "hiddenbar"
      "karabiner-elements"
      "keyclu"
      "logi-options+"
      "notion"
      "obsidian"
      "onedrive"
      "open-video-downloader"
      "orbstack"
      "postman"
      "prismlauncher"
      "raycast"
      "rectangle"
      "rustdesk"
      "shottr"
      "sikarugir"
      "sonobus"
      "spotify"
      "steam"
      "stillcolor"
      "syncthing-app"
      "wireshark-app"
      "zed"
    ];
  };

  # Security / Nix settings
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
