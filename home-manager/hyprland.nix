{pkgs, ...}: {
  programs.kitty.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    settings = {
      "$mod" ="SUPER";
      bind = [
        "$mod, G, exec, ghostty"
        "$mod, C, exec, code"
        "$mod, S, exec, supotify"
        "$mod, B, exec, brave"
      ];
    };
    plugins = [
      pkgs.hyprlandPlugins.hy3
      pkgs.hyprlandPlugins.hyprbars
      # pkgs.hyprlandPlugins.hyprwinwrap
      pkgs.hyprlandPlugins.borders-plus-plus
    ];
  };
}
