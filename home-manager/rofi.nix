{ pkgs, ... }: {
    programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        theme = ./rofi.rasi; # referd from https://github.com/turtton/dotnix/blob/main/home-manager/wm/hyprland/rofi/default.nix
    };
    home.packages = with pkgs; [
        bemoji
    ];
    # https://github.com/marty-oehme/bemoji?tab=readme-ov-file#adding-your-own-emoji
    xdg.dataFile."bemoji/shortcodes.txt".source = ./bemoji.txt;
}