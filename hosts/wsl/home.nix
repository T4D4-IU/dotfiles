{...}: {
  # This value determines the Home Manager release that your configuration is
  # compatible with.
  home.stateVersion = "24.11";

  # Define features for this host
  features = {
    gui = false;
  };

  # Import modular configurations
  # WSLではGUIモジュールをインポートしない（CLI専用）
  imports = [
    # Common modules (cross-platform)
    ../../modules/home/common

    # Linux GUI modules are NOT imported for WSL
    # ../../modules/home/linux
  ];

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };

  # WSL-specific settings
  home.sessionVariables = {
    # WSL特有の環境変数があればここに追加
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
