{
  pkgs,
  lib,
  features ? {},
  ...
}:
# Common modules that should be loaded on all systems
let
  guiEnabled = features.gui or true;
in {
  imports =
    [
      ./cli.nix
      ./development.nix
      ./direnv.nix
      ./gh.nix
      ./git.nix
      ./jujutsu.nix
      ./starship.nix
      ./zoxide.nix
      ./zsh.nix
    ]
    ++ lib.optional (pkgs.stdenv.isDarwin && guiEnabled) ../darwin
    ++ lib.optional (pkgs.stdenv.isLinux && guiEnabled) ../linux;
}
