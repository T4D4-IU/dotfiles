{
  lib,
  inputs,
  features ? {},
  isDarwin ? false,
  isLinux ? false,
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
      inputs.my-helix.homeManagerModules.default
    ]
    ++ lib.optional (isDarwin && guiEnabled) ../darwin
    ++ lib.optional (isLinux && guiEnabled) ../linux;
}
