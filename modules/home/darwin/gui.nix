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

    # Home Manager installs .app bundles to ~/.nix-profile/Applications/, but
    # macOS Spotlight and Launchpad only search /Applications/ and ~/Applications/.
    # This activation script symlinks all managed .app bundles into
    # ~/Applications/Home Manager Apps/ so they are discoverable by macOS.
    home.activation.linkApps = lib.hm.dag.entryAfter ["writeBoundary"] ''
      app_folder="$HOME/Applications/Home Manager Apps"
      # Safety check: ensure the target is within $HOME and has the expected suffix
      case "$app_folder" in
        "$HOME/"*"Home Manager Apps")
          rm -rf "$app_folder"
          mkdir -p "$app_folder"
          if [ -d "$newGenPath/home-path/Applications" ]; then
            find -L "$newGenPath/home-path/Applications" -maxdepth 1 -name "*.app" \
              -print0 | while IFS= read -r -d "" app; do
                ln -sf "$app" "$app_folder/"
              done
          fi
          ;;
      esac
    '';
  };
}
