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
    networkmanagerapplet # network manager gui
    blueberry # Bluetooth configuration tool
  ];
}
