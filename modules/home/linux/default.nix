{...}:
# Linux-specific modules
{
  imports = [
    ../common/code-server.nix
    ./gui.nix
    ./zed.nix
  ];
}
