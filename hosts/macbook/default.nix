{ pkgs, ... }: {
  # Nix-darwin configuration entry point for MacBook

  # Set the primary user for system activation
  system.primaryUser = "t4d4";

  # Disable nix-darwin's management of the Nix installation
  # since we are using Determinate Nix.
  nix.enable = false;

  # System state version
  system.stateVersion = 5;

  # Homebrew for GUI Apps and System-level tools
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap"; # Removes unmanaged packages
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

  # Japanese Localization
  system.defaults.CustomUserPreferences."com.apple.GlobalDomain" = {
    AppleLanguages = [ "ja-JP" "en-US" ];
    AppleLocale = "ja_JP";
  };

  # Keyboard & Trackpad settings
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 15; # Fast repeat delay
  system.defaults.NSGlobalDomain.KeyRepeat = 2; # Fast repeat rate
  system.defaults.NSGlobalDomain."com.apple.keyboard.fnState" = true; # Use F1, F2 etc. as standard function keys

  # Security / Nix settings
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
