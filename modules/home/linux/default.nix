{ config, pkgs, lib, ... }:

# Linux-specific modules
{
  imports = [
    ./gui.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./rofi.nix
    ./security.nix
  ];
}
