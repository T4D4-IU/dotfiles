{pkgs, ...}: {
  # This value determines the Home Manager release that your configuration is
  # compatible with.
  home.stateVersion = "24.11";

  # Import modular configurations
  # WSLではGUIモジュールをインポートしない（CLI専用）
  imports = [
    # Common modules (cross-platform)
    ../../modules/home/common

    # Linux GUI modules are NOT imported for WSL
    # ../../modules/home/linux
  ];

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # WSL-specific settings
  home.sessionVariables = {
    # WSL特有の環境変数があればここに追加
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
