{...}: {
  # This value determines the Home Manager release that your configuration is
  # compatible with.
  home.stateVersion = "24.11";

  # Define features for this host
  features = {
    gui = true;
  };

  # Import modular configurations
  imports = [
    # Common modules (cross-platform)
    ../../modules/home/common

    # macOS-specific modules
    ../../modules/home/darwin
  ];

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };

  # macOS-specific session variables
  home.sessionVariables = {
    # macOS-specific session variables (macOS特有の環境変数があればここに追加)
  };

  # Karabiner-Elements configuration
  # Swaps Cmd/Ctrl and maps Backtick (Half/Full-width) to Japanese toggle
  home.file.".config/karabiner/karabiner.json".text = builtins.toJSON {
    profiles = [
      {
        name = "Default";
        selected = true;
        simple_modifications = [
          {
            from = { key_code = "left_command"; };
            to = [{ key_code = "left_control"; }];
          }
          {
            from = { key_code = "left_control"; };
            to = [{ key_code = "left_command"; }];
          }
          {
            from = { key_code = "right_command"; };
            to = [{ key_code = "right_control"; }];
          }
          {
            from = { key_code = "right_control"; };
            to = [{ key_code = "right_command"; }];
          }
          {
            from = { key_code = "grave_accent_and_tilde"; };
            to = [{ key_code = "japanese_eisuu"; }];
          }
        ];
        complex_modifications = {
          parameters = {
            "basic.simultaneous_threshold_milliseconds" = 50;
          };
          rules = [
            {
              description = "Apply Windows-like Japanese Toggle with Grave Accent key";
              manipulators = [
                {
                  from = { key_code = "grave_accent_and_tilde"; };
                  type = "basic";
                  to = [{ key_code = "japanese_eisuu"; }];
                  conditions = [{
                    type = "input_source_if";
                    input_sources = [{ language = "ja"; }];
                  }];
                }
                {
                  from = { key_code = "grave_accent_and_tilde"; };
                  type = "basic";
                  to = [{ key_code = "japanese_kana"; }];
                  conditions = [{
                    type = "input_source_unless";
                    input_sources = [{ language = "ja"; }];
                  }];
                }
              ];
            }
          ];
        };
      }
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
