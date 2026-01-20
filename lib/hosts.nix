_:
# Define host configurations in a structured format
{
  nixos = {
    system = "x86_64-linux";
    hostname = "nixos";
    username = "t4d4";
    homeDirectory = "/home/t4d4";

    # Features enabled for this host
    features = {
      gui = true;
      development = true;
    };

    # Host-specific modules
    nixosModules = [
      ../hosts/nixos
    ];

    homeModules = [
      ../hosts/nixos/home.nix
    ];
  };

  # WSL/Ubuntu environment (CLI-only)
  wsl = {
    system = "x86_64-linux";
    hostname = "wsl";
    username = "t4d4"; # Change to your WSL username
    homeDirectory = "/home/t4d4"; # Change to your home directory

    features = {
      gui = false; # No GUI on WSL
      development = true;
    };

    homeModules = [
      ../hosts/wsl/home.nix
    ];
  };

  # Future hosts can be added here
  # Example for macOS:
  # macbook = {
  #   system = "aarch64-darwin";
  #   hostname = "macbook";
  #   username = "t4d4";
  #   homeDirectory = "/Users/t4d4";
  #
  #   features = {
  #     gui = true;
  #     development = true;
  #   };
  #
  #   homeModules = [
  #     ../hosts/macbook/home.nix
  #   ];
  # };
}
