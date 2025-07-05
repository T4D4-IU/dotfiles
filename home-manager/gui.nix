{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brave
    discord
    obsidian
    anki
    zulip
    slack
    telegram-desktop
    spotify
    syncthing
    rquickshare # rust implementation of quickshare
    wireshark # Powerful network protocol analyzer
    waybar # Highly customizable Wayland bar for Sway and Wlroots based compositors
    dunst # Lightweight and customizable notification daemon
    wlogout # Wayland based logout menu
    zenity
    networkmanagerapplet # network manager gui
    blueberry # Bluetooth configuration tool
    armitage # Graphical cyber attack management tool for Metasploit
  ];
}
