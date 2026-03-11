{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.features.gui {
    home.packages = with pkgs; [
      # GUI Applications available on macOS
      discord
      obsidian
      spotify
      brave
      raycast
      syncthing
      notion-app
    ];
  };
}
