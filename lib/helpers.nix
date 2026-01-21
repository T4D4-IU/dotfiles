{lib}: {
  # Create a home-manager configuration for a given host
  mkHomeConfiguration = {
    inputs,
    system,
    username,
    homeDirectory,
    modules ? [],
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [(import inputs.rust-overlay)];
      };
      extraSpecialArgs = {
        inherit inputs;
      };
      modules =
        [
          {
            home = {
              inherit username homeDirectory;
              stateVersion = "24.11";
            };
            programs.home-manager.enable = true;
            nixpkgs.config.allowUnfree = true;
          }
        ]
        ++ modules;
    };

  # Create a NixOS configuration for a given host
  mkNixosConfiguration = {
    inputs,
    system,
    modules ? [],
    ...
  }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      inherit modules;
      specialArgs = {
        inherit inputs;
      };
    };

  # OS detection helpers
  isLinux = system: lib.hasSuffix "-linux" system;
  isDarwin = system: lib.hasSuffix "-darwin" system;

  # Architecture detection
  isx86_64 = system: lib.hasPrefix "x86_64-" system;
  isAarch64 = system: lib.hasPrefix "aarch64-" system;

  # System type helpers
  systemType = system:
    if lib.hasSuffix "-linux" system
    then "linux"
    else if lib.hasSuffix "-darwin" system
    then "darwin"
    else "unknown";

  # Conditionally include modules based on OS
  optionalModules = {
    linux = condition: modules:
      if condition
      then modules
      else [];
    darwin = condition: modules:
      if condition
      then modules
      else [];
  };
}
