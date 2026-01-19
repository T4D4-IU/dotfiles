{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "t4d4";
  home.homeDirectory = "/home/t4d4";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # Import modular configurations
  imports = [
    # Common modules (cross-platform)
    ../../modules/home/common
    
    # Linux-specific modules (only for this host)
    ../../modules/home/linux
  ];

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager.
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
