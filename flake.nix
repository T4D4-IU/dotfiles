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
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    pre-commit-hooks,
    ...
  } @ inputs: let
    # Import our helper library
    lib = nixpkgs.lib;
    myLib = import ./lib {inherit lib;};
    helpers = myLib.helpers;
    hosts = myLib.hosts;

    # Systems to support
    systems = ["x86_64-linux" "aarch64-darwin" "x86_64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages.x86_64-linux = let
      pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
    in {
      dfx = pkgs.callPackage ./pkgs/dfx.nix {};
      haystack-editor = pkgs.callPackage ./pkgs/haystack-editor.nix {};
    };
    packageChecks = let
      system = "x86_64-linux";
    in
      builtins.listToAttrs (
        builtins.map (name: {
          inherit name;
          value = self.packages.${system}.${name};
        }) (builtins.attrNames self.packages.${system})
      );
    checks = forAllSystems (
      system: let
        pkgs = import nixpkgs {inherit system;};
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            # Nix formatting with alejandra
            alejandra.enable = true;

            # Nix linting
            statix.enable = true;
            deadnix.enable = true;

            # Additional checks
            check-merge-conflicts.enable = true;
            end-of-file-fixer.enable = true;
            trim-trailing-whitespace.enable = true;
          };
        };
      in
        if system == "x86_64-linux"
        then
          self.packageChecks
          // {
            nixos = self.nixosConfigurations.nixos.config.system.build.toplevel;
            home-manager = self.homeConfigurations."t4d4@nixos".activationPackage;
            pre-commit = pre-commit-check;
          }
        else {
          pre-commit = pre-commit-check;
        }
    );

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

    # Development shell
    devShells = forAllSystems (
      system: let
        pkgs = import nixpkgs {inherit system;};
        pre-commit-check = self.checks.${system}.pre-commit;
      in {
        default = pkgs.mkShell {
          name = "dotfiles-dev";

          packages = with pkgs; [
            # Formatters
            alejandra # Nix code formatter (official)
            nixfmt-rfc-style # Alternative formatter

            # Linters
            statix # Lints and suggestions for Nix
            deadnix # Find unused code

            # Development tools
            nil # Nix LSP

            # Pre-commit
            pre-commit
          ];

          shellHook = ''
            ${pre-commit-check.shellHook}
            echo ""
            echo "🛠️  Dotfiles development environment"
            echo ""
            echo "Pre-commit hooks are installed!"
            echo "They will run automatically on 'git commit'."
            echo ""
            echo "Manual commands:"
            echo "  alejandra .             # Format all files"
            echo "  statix check .          # Run linter"
            echo "  deadnix .               # Check for dead code"
            echo "  pre-commit run --all    # Run all pre-commit hooks"
            echo ""
          '';
        };
      }
    );
  };
}
