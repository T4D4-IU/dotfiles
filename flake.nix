{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    xremap.url = "github:xremap/nix-flake";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... }@inputs: {
    packages.x86_64-linux = let
      pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
      in {
        dfx = pkgs.callPackage ./pkgs/dfx.nix { };
        haystack-editor = pkgs.callPackage ./pkgs/haystack-editor.nix { };
      };
    checks.x86_64-linux = {
      nixos = self.nixosConfigurations.nixos.config.system.build.toplevel;
      home-manager = self.homeConfigurations."t4d4@nixos".activation-script;
    };
      nixosConfigurations = {
        nixos = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            ];
          specialArgs = {
            inherit inputs;
            };
          };
        };
      homeConfigurations = {
      "t4d4@nixos" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true; # プロプライエタリなパッケージを許可
        };
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [
          ./home.nix
        ];
      };
    };
  };
}
