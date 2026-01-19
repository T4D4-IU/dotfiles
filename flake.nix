{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    xremap.url = "github:xremap/nix-flake";
    rust-overlay.url = "github:oxalica/rust-overlay";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: 
    let
      # Import our helper library
      lib = nixpkgs.lib;
      myLib = import ./lib { inherit lib; };
      helpers = myLib.helpers;
      hosts = myLib.hosts;
    in
    {
    packages.x86_64-linux = let
      pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
      in {
        dfx = pkgs.callPackage ./pkgs/dfx.nix { };
        haystack-editor = pkgs.callPackage ./pkgs/haystack-editor.nix { };
      };
    packageChecks = let system = "x86_64-linux"; in builtins.listToAttrs (
      builtins.map (name: {
        inherit name;
        value = self.packages.${system}.${name};
      }) (builtins.attrNames self.packages.${system})
    );
    checks.x86_64-linux = self.packageChecks // {
      nixos = self.nixosConfigurations.nixos.config.system.build.toplevel;
      home-manager = self.homeConfigurations."t4d4@nixos".activation-script;
    };

    # NixOS Configurations using helper
    nixosConfigurations = {
      nixos = helpers.mkNixosConfiguration {
        inherit inputs;
        system = hosts.nixos.system;
        hostname = hosts.nixos.hostname;
        modules = hosts.nixos.nixosModules;
      };
    };

    # Home Manager Configurations using helper
    homeConfigurations = {
      "t4d4@nixos" = helpers.mkHomeConfiguration {
        inherit inputs;
        system = hosts.nixos.system;
        username = hosts.nixos.username;
        homeDirectory = hosts.nixos.homeDirectory;
        modules = hosts.nixos.homeModules;
      };
      
      # WSL/Ubuntu environment (CLI-only)
      "t4d4@wsl" = helpers.mkHomeConfiguration {
        inherit inputs;
        system = hosts.wsl.system;
        username = hosts.wsl.username;
        homeDirectory = hosts.wsl.homeDirectory;
        modules = hosts.wsl.homeModules;
      };
    };
  };
}
