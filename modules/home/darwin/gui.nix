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

    # Mac applications installed via Home Manager aren't typically indexed by Spotlight
    # because they are symlinks to /nix/store. We create native macOS aliases instead.
    home.activation.copyMacApps = lib.hm.dag.entryAfter ["writeBoundary"] ''
      apps_source="$newGenPath/home-path/Applications"
      configured_home="${config.home.homeDirectory}"
      apps_target="$configured_home/Applications/Nix Apps"

      # Basic safety checks to avoid deleting unintended paths
      if [ -z "$configured_home" ]; then
        echo "Configured home directory is empty; refusing to create Mac application aliases."
        exit 1
      fi

      if [ -z "$HOME" ]; then
        echo "HOME is not set; skipping Mac application alias creation."
        exit 0
      fi

      if [ "$HOME" != "$configured_home" ]; then
        echo "Activation HOME ('$HOME') does not match configured home ('$configured_home'); skipping Mac application alias creation."
        exit 0
      fi

      # Refuse to remove clearly unsafe targets
      case "$apps_target" in
        ""|"/"|"$configured_home"|"/Applications" )
          echo "Refusing to remove unsafe apps_target path: '$apps_target'."
          exit 1
          ;;
      esac

      # Always remove and recreate the aliases directory to avoid stale aliases
      rm -rf "$apps_target"
      mkdir -p "$apps_target"

      if [ -d "$apps_source" ]; then
        echo "Creating Mac application aliases in $apps_target..."

        for app in "$apps_source"/*.app; do
          if [ -L "$app" ]; then
            real_app=$(readlink "$app")
            app_name=$(basename "$app")
            echo "Aliasing $app_name..."
            ${pkgs.mkalias}/bin/mkalias "$real_app" "$apps_target/$app_name"
          fi
        done
      fi
    '';
  };
}
