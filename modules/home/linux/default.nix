{
  config,
  lib,
  ...
}:
# Linux-specific modules
{
  imports = [
    ./gui.nix
  ];
}
