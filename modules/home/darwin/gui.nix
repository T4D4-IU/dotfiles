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
      apps_target="$HOME/Applications/Nix Apps"
      
      if [ -e "$apps_source" ]; then
        echo "Creating Mac application aliases in $apps_target..."
        
        # Remove the old aliases directory and recreate it
        rm -rf "$apps_target"
        mkdir -p "$apps_target"
        
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
