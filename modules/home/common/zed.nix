{
  programs.zed-editor = {
    enable = true;
  };
  home.file.".config/zed/settings.json".text = ''
    {
      "theme": "Catppuccin Mocha - No Italics",
      "ui_font_size": 14,
      "buffer_font_family": "JetBrainsMono Nerd Font",
      "buffer_font_size": 14,
      "vim_mode": true,
      "relative_line_numbers": true,
      "scrollbar": {
        "show": "never"
      },
      "buffer_line_height": {
        "custom": 1.5
      },
      "inlay_hints": {
        "enabled": true,
        "show_type_hints": true,
        "show_parameter_hints": true,
        "show_other_hints": true,
        "edit_debounce_ms": 700,
        "scroll_debounce_ms": 50
      },
      "lsp": {
        "rust-analyzer": {
          "check": {
            "extraArgs": ["--target-dir", "target/ra"]
          },
          "initialization_options": {
            "check": {
              "command": "check"
            }
          }
        }
      },
      "terminal": {
        "alternate_scroll": "off",
        "blinking": "terminal_controlled",
        "copy_on_select": true,
        "font_family": "JetBrainsMono Nerd Font",
        "toolbar": {
          "title": true
        },
        "line_height": {
          "custom": 1.5
        },
        "working_directory": "current_project_directory"
      }
    }
  '';
  home.file.".config/zed/keymap.json".text = ''
    [
      {
        "context": "Editor && (vim_mode == normal || vim_mode == visual) && !VimWaiting && !menu",
        "bindings": {
          "ctrl-h": ["workspace::ActivatePaneInDirection", "Left"],
          "ctrl-l": ["workspace::ActivatePaneInDirection", "Right"],
          "ctrl-k": ["workspace::ActivatePaneInDirection", "Up"],
          "ctrl-j": ["workspace::ActivatePaneInDirection", "Down"],
          "space c": "pane::CloseActiveItem",
          "space b c": "pane::CloseInactiveItems",
          "space b C": "pane::CloseAllItems",
          "space e": "workspace::ToggleLeftDock",
          "space f f": "file_finder::Toggle",
          "space l a": "editor::ToggleCodeActions",
          "space l d": "diagnostics::Deploy",
          "space l f": "editor::Format",
          "space l s": "outline::Toggle",
          "space l r": "editor::Rename",
          "space o": "tab_switcher::Toggle",
          "space t h": "workspace::OpenInTerminal",
          "space t f": "workspace::NewCenterTerminal",
          "space /": "editor::ToggleComments",
          "g d v": "editor::GoToDefinitionSplit",
          "g r": "editor::FindAllReferences",
          ">": "vim::Indent"
        }
      },
      {
        "context": "Terminal",
        "bindings": {
          "ctrl-k": ["workspace::ActivatePaneInDirection", "Up"],
          "ctrl-j": ["workspace::ActivatePaneInDirection", "Down"]
        }
      }
    ]
  '';
}
