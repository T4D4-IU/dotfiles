{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.features.gui {
    # GUI Applications are now managed via Homebrew in hosts/macbook/default.nix
    # to ensure proper registration with macOS security settings.
    home.packages = with pkgs; [
      # Common GUI tools (CLI-based or non-app-bundle) can go here
    ];
  };
}
