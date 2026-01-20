{lib, ...}: {
  # Import all helper modules
  helpers = import ./helpers.nix {inherit lib;};
  hosts = import ./hosts.nix {inherit lib;};
}
