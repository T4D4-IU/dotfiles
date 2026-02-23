{lib, ...}:
# Common modules that should be loaded on all systems
{
  options = {
    features.gui = lib.mkEnableOption "GUI applications and utilities" // {default = true;};
  };

  imports = [
    ./cli.nix
    ./code-server.nix
    ./development.nix
    ./direnv.nix
    ./gh.nix
    ./git.nix
    ./jujutsu.nix
    ./starship.nix
    ./zoxide.nix
    ./zsh.nix
  ];
}
