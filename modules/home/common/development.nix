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
    code-server
    devbox
    devenv
    act # GitHub Actionsのローカル実行
    actionlint # Static checker for GitHub Actions workflow files
    amp-cli
    cachix
    gemini-cli
    github-copilot-cli
    marp-cli
    pinact # Pin GitHub Actions versions
    textlint
    valgrind # memory leak detector
    zizmor # static analysis tool for GitHub Actions
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
