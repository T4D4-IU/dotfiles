{...}: {
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ../../modules/secrets.nix
    ../../modules/nixos
  ];
}
