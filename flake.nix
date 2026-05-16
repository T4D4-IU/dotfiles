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
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    my-secrets = {
      url = "git+ssh://git@github.com/T4D4-IU/dotfiles-secrets";
      flake = false;
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
    inherit (nixpkgs) lib;
    myLib = import ./lib {inherit lib;};
    inherit (myLib) helpers;
    inherit (myLib) hosts;

    # Systems to support
    systems = ["x86_64-linux" "aarch64-darwin" "x86_64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs systems;

    # Internal helper for package checks
    packageChecks = let
      system = "x86_64-linux";
    in
      builtins.listToAttrs (
        builtins. map (name: {
          inherit name;
          value = self. packages.${system}.${name};
        }) (builtins.attrNames self.packages.${system})
      );
  in {
    packages = forAllSystems (
      system: let
        pkgs = import inputs.nixpkgs {inherit system;};

        # パッケージの定義
        allPkgs = {
          dfx = pkgs.callPackage ./pkgs/dfx.nix {};
          haystack-editor = pkgs.callPackage ./pkgs/haystack-editor.nix {};
        };
      in
        # そのシステム（アーキテクチャ）をサポートしているパッケージのみを公開する
        lib.filterAttrs (
          _name: pkg: let
            platforms = pkg.meta.platforms or [system];
          in
            builtins.elem system platforms
        )
        allPkgs
    );

    checks = forAllSystems (
      system: let
        pre-commit-check = pre-commit-hooks. lib.${system}.run {
          src = ./.;
          hooks = {
            # Nix formatting with alejandra
            alejandra.enable = true;

            # Nix linting
            statix = {
              enable = true;
              # バグ回避: --ignoreフラグに値が必要なため、ダミーの除外対象を指定
              settings.ignore = [".direnv"];
            };
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
          packageChecks
          // {
            nixos = self.nixosConfigurations.nixos.config. system.build.toplevel;
            home-manager = self.homeConfigurations."t4d4@nixos".activationPackage;
            pre-commit = pre-commit-check;
          }
        else {
          pre-commit = pre-commit-check;
        }
    );

    # NixOS Configurations using helper
    nixosConfigurations = lib.mapAttrs (
      _name: host:
        helpers.mkNixosConfiguration {
          inherit inputs;
          inherit (host) system;
          features = host.features or {};
          modules = host.nixosModules;
        }
    ) (lib.filterAttrs (_name: host: host ? nixosModules) hosts);

    # Darwin (macOS) Configurations using helper
    darwinConfigurations = lib.mapAttrs (
      _name: host:
        helpers.mkDarwinConfiguration {
          inherit inputs;
          inherit (host) system;
          features = host.features or {};
          modules = host.darwinModules;
        }
    ) (lib.filterAttrs (_name: host: host ? darwinModules) hosts);

    # Home Manager Configurations using helper
    homeConfigurations = builtins.listToAttrs (
      lib.mapAttrsToList (name: host: {
        name = "${host.username}@${name}";
        value = helpers.mkHomeConfiguration {
          inherit inputs;
          inherit (host) system username homeDirectory;
          features = host.features or {};
          modules = host.homeModules;
        };
      }) (lib.filterAttrs (_name: host: host ? homeModules) hosts)
    );

    # Automatic environment detection script (run with `nix run .`)
    apps = forAllSystems (system: let
      pkgs = import inputs.nixpkgs {inherit system;};
      applyScript = pkgs.writeShellScriptBin "apply" ''
        set -euo pipefail

        OS="$(uname -s)"
        HOSTNAME="''${1:-$(hostname -s)}"
        USER="$(whoami)"

        echo "====================================="
        echo "🛠️  Dotfiles Apply Script"
        echo "OS:       $OS"
        echo "Hostname: $HOSTNAME"
        echo "User:     $USER"
        echo "====================================="

        if [ "$OS" = "Darwin" ]; then
          echo "Applying macOS (Darwin) configuration..."
          nix run ${inputs.darwin} -- switch --flake .#$HOSTNAME
        elif [ "$OS" = "Linux" ]; then
          if grep -q "NixOS" /etc/os-release 2>/dev/null; then
            echo "Applying NixOS configuration..."
            sudo nixos-rebuild switch --flake .#$HOSTNAME
          else
            echo "Applying Home Manager configuration (Linux non-NixOS)..."
            nix run ${inputs.home-manager} -- switch --flake .#$USER@$HOSTNAME
          fi
        else
          echo "❌ Unsupported OS: $OS"
          exit 1
        fi
      '';
    in {
      default = {
        type = "app";
        program = "${applyScript}/bin/apply";
      };
      apply = {
        type = "app";
        program = "${applyScript}/bin/apply";
      };
    });

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

            # Linters
            statix # Lints and suggestions for Nix
            deadnix # Find unused code

            # Development tools
            nil # Nix LSP

            # Encryption
            sops
            age
            ssh-to-age

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
            echo "  statix check .           # Run linter"
            echo "  deadnix .               # Check for dead code"
            echo "  pre-commit run --all    # Run all pre-commit hooks"
            echo ""
          '';
        };
      }
    );
  };
}
