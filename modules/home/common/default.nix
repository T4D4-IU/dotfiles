{lib, ...}:
# Common modules that should be loaded on all systems
{
  options = {
    features.gui = lib.mkEnableOption "GUI applications and utilities" // {default = true;};
  };

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
