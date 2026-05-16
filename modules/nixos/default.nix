# ===========================================================================
# Base NixOS Module
# ===========================================================================
{lib, ...}: {
  # Common system-level settings for NixOS hosts
  time.timeZone = lib.mkDefault "Asia/Tokyo";
  i18n.defaultLocale = lib.mkDefault "ja_JP.UTF-8";

  # Enable flake support
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
