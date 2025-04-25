{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wofi
    waybar
    grimblast
    hyprpaper
  ];
  programs.kitty.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    settings = {
      "$mod" ="SUPER";
      "$menu" = "wofi --show drun";
      bind = [
        "$mod, G, exec, ghostty"
        "$mod, C, exec, code"
        "$mod, S, exec, spotify"
        "$mod, B, exec, brave"
        "$mod, Q, killactive"
        ", Print, exec, grimblast copy area"
        "$mod, D, exec, $menu"
        "$mod, M, exit"
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
