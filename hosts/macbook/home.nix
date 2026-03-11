{...}: {
  # This value determines the Home Manager release that your configuration is
  # compatible with.
  home.stateVersion = "24.11";

  # Define features for this host
  features = {
    gui = true;
  };

  # Import modular configurations
  imports = [
    # Common modules (cross-platform)
    ../../modules/home/common

    # macOS-specific modules
    ../../modules/home/darwin
  ];

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };

  # macOS-specific session variables
  home.sessionVariables = {
    # macOS-specific session variables (macOS特有の環境変数があればここに追加)
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
