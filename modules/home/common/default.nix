{ config, pkgs, lib, ... }:

# Common modules that should be loaded on all systems
{
  imports = [
    ./cli.nix
    ./dev.nix
    ./development.nix
    ./direnv.nix
    ./starship.nix
    ./zed.nix
    ./zsh.nix
  ];
}
