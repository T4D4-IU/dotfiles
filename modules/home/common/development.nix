{pkgs, ...}: {
  home.packages = with pkgs; [
    # warp-terminal
    gcc
    nodejs-slim # npmのないNode.js単体
    nodePackages.pnpm
    # nodePackages.wrangler # Cloudflare Workers CLI
    deno
    bun
    # postman
    # mise
    foundry
    # wasmer # ユニバーサルWebAssemblyランタイム - ビルドエラーのため一時的にコメントアウト
    (rust-bin.stable.latest.default.override {
      targets = [
        "wasm32-unknown-unknown"
        # "wasm32-wasi" # 最新のStable版ではサポートされていない？
      ];
    })
    cargo-shuttle
    cargo-llvm-cov # Rustのカバレッジ計測ツール
    cargo-binutils # cargo-llvm-covに使う
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
