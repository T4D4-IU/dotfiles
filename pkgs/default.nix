# default.nix
let
    nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.05";
    pkgs = import nixpkgs { config = {}; overlays = []; };
in
{
    dfx = pkgs.callPackage ./dfx.nix { };
    haystack-editor = pkgs.callPackage ./haystack-editor.nix { };
}