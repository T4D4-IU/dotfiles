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
      # Use the configured home directory instead of relying solely on $HOME.
      app_folder="${config.home.homeDirectory}/Applications/Home Manager Apps"

      # Safety checks:
      # 1. Ensure HOME is set.
      # 2. Ensure HOME matches the configured home directory.
      # 3. Ensure app_folder is exactly the expected path under HOME.
      if [ -z "$HOME" ]; then
        echo "home.activation.linkApps: HOME is not set; refusing to modify filesystem." >&2
        exit 1
      fi

      if [ "$HOME" != "${config.home.homeDirectory}" ]; then
        echo "home.activation.linkApps: HOME ($HOME) does not match configured home (${config.home.homeDirectory}); refusing to modify filesystem." >&2
        exit 1
      fi

      expected_app_folder="$HOME/Applications/Home Manager Apps"
      if [ "$app_folder" != "$expected_app_folder" ]; then
        echo "home.activation.linkApps: Refusing to operate on unexpected app_folder: $app_folder" >&2
        exit 1
      fi

      rm -rf "$app_folder"
      mkdir -p "$app_folder"
      if [ -d "$newGenPath/home-path/Applications" ]; then
        find -L "$newGenPath/home-path/Applications" -maxdepth 1 -name "*.app" \
          -print0 | while IFS= read -r -d "" app; do
            ln -sf "$app" "$app_folder/"
          done
      fi
    '';
  };
}
