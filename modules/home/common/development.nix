{pkgs, ...}: {
  home.packages = with pkgs; [
    # warp-terminal
    # nodePackages.wrangler # Cloudflare Workers CLI
    # postman
    # mise
    # wasmer # ユニバーサルWebAssemblyランタイム - ビルドエラーのため一時的にコメントアウト
    # vscode
    # jetbrains-toolbox
    # zenn-cli # textlintとpnpm lock.yamlが競合するため一時的にコメントアウト
    wakatime-cli
    ghq # Remote repository management made easy
    gibo # Gitignore boilerplate generator
    # claude-code # AI code generator
    devbox
    devenv
    github-copilot-cli
    gemini-cli
    amp-cli
  ];
  # programs.ghostty = {
  #   enable = true;
  #   settings = {
  #     theme = "catppuccin-mocha";
  #     window-padding-x = 10;
  #     window-padding-y = 5;
  #     window-padding-balance = true;
  #     background-opacity = 0.85;
  #     background-blur-radius = 20;
  #   };
  # };
}
