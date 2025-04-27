{pkgs, ...}: {
  programs.kitty.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
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
        ", Print, exec, grimblast copysave area"
        "$mod, D, exec, rofi -show drun"
        "$mod, period, exec, bemoji"
        "$mod, M, exit"
        "$mod, F, fullscreen"
        "$mod, X, exec, wlogout"
        #"$mod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
        "$mod, V, exec, rofi -modi clipboard:${pkgs.cliphist}/bin/cliphist-rofi-img -show clipboard -show-icons -theme-str '##element-icon {size: 5ch; }'"
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
        # move focus
        "$mod, left, movefocus, left"
        "$mod, right, movefocus, right"
        "$mod, up, movefocus, up"
        "$mod, down, movefocus, down"
        "$mod, Tab, cyclenext"
        "$mod, Shift, Tab, cyclenext, prev"
      ];
      exec-once = [
        "syncthing"
        "fcitx5 -D"
        "rquickshare"
        "discord"
      ];
      env = [
        "XMODIFIERS, @im=fcitx5"
      ];
      xwayland = {
        enable = true;
        force_zero_scaling = true;
      };
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
