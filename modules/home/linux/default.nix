{ config, pkgs, lib, ... }:

# Linux-specific modules
{
  imports = [
    ./gui.nix
  ];
}
