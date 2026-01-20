{pkgs, ...}: {
  home.packages = with pkgs; [
    # GUI Applications
    brave
    discord
    obsidian
    anki
    zulip
    slack
    # telegram-desktop
    spotify
    syncthing
    rquickshare # rust implementation of quickshare
    # wireshark # Powerful network protocol analyzer
    networkmanagerapplet # network manager gui
    blueberry # Bluetooth configuration tool

    # Wayland/Linux GUI utilities
    # grimblast # Helper for screenshots within Hyprland, based on grimshot
    # hyprpaper # Blazing fast wayland wallpaper utility
    # cliphist # Wayland clipboard History
    # wl-clipboard # Wayland clipboard manager
    # brightnessctl # Screen brightness control
  ];
}
