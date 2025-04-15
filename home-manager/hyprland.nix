{pkgs, ...}: {
  wayland.windowManager.hyprland = {
    settings = {
      decoration = {
        shadow_offset = 0.5;
        "col.shadow" = "#000099";
      };
    };
    plugins = with pkgs.hyprlandPlugins;[
      hypr-dynamic-cursors
      hyprtrails
      hyprwinwrap
    ];
  };
}
