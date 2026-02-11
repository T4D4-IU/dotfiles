{lib, ...}:
# Common modules that should be loaded on all systems
{
  options = {
    features.gui = lib.mkEnableOption "GUI applications and utilities" // {default = true;};
  };

  imports = [
    ./cli.nix
    ./development.nix
    ./direnv.nix
    ./gh.nix
    ./git.nix
    ./starship.nix
    ./tailscale.nix
    ./zoxide.nix
    ./zsh.nix
  ];
}
