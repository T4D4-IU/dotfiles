{pkgs, ...}: {
  programs.kitty.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = null;
    portalPackage = null;
    settings = {
      "$mod" ="SUPER";
      "$alt" = "ALT";
      bind = [
        "$mod, G, exec, ghostty"
        "$mod, C, exec, code"
        "$mod, S, exec, spotify"
        "$mod, B, exec, brave"
        "$mod, Q, killactive"
        ", Print, exec, grimblast copy area"
        "$mod, D, exec, rofi -show drun"
        "$mod, period, exec, bemoji"
        "$mod, M, exit"
        "$mod, X, exec, wlogout"
        "$mod, V, exec, cliphist list"
        # switch workspaces
        "$alt, 1, workspace, 1"
        "$alt, 2, workspace, 2"
        "$alt, 3, workspace, 3"
        "$alt, 4, workspace, 4"
        "$alt, 5, workspace, 5"
        "$alt, 6, workspace, 6"
        "$alt, 7, workspace, 7"
        "$alt, 8, workspace, 8"
        "$alt, 9, workspace, 9"
      ];
      exec-once = [
        "syncthing"
        "fcitx5 -D"
      ];
      env = [
        "XMODIFIERS, @im=fcitx5"
      ];
    };
#    plugins = [
#      pkgs.hyprlandPlugins.hy3
#      pkgs.hyprlandPlugins.hyprbars
#      pkgs.hyprlandPlugins.hyprwinwrap
#      pkgs.hyprlandPlugins.borders-plus-plus
#    ];
  };
  services.gnome-keyring.enable = true;
}
