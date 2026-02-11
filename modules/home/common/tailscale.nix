{pkgs, ...}: {
  home.packages = with; [
    tailscale
  ];
}
