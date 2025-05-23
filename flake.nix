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

  outputs = inputs: {
    packages.x86_64-linux = let
      pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
      in {
        dfx = pkgs.callPackage ./pkgs/dfx.nix { };
        haystack-editor = pkgs.callPackage ./pkgs/haystack-editor.nix { };
      };
      nixosConfigurations = {
        myNixOS = inputs.nixpkgs.lib.nixosSystem {
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
      myHome = inputs.home-manager.lib.homeManagerConfiguration {
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
