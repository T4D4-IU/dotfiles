_: {
  # Nix-darwin configuration entry point for MacBook

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
    onActivation.cleanup = "uninstall"; # Use standard cleanup to avoid aggressively zapping unmanaged packages
    casks = [
      "karabiner-elements"
      "brave-browser"
      "discord"
      "notion"
      "obsidian"
      "raycast"
      "spotify"
      "syncthing"
    ];
  };

  # Security / Nix settings
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
