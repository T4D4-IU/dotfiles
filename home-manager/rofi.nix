{ pkgs, ... }: {
    programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        theme = ./rofi.rasi; # referd from https://github.com/turtton/dotnix/blob/main/home-manager/wm/hyprland/rofi/default.nix
    };
}