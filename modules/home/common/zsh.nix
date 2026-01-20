{
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
    };
    syntaxHighlighting.enable = true;
    shellAliases = {
      # zshで呼ぶコマンドのエイリアスを設定
      cd = "z";
      ls = "eza --icons always --classify always";
      la = "eza --icons always --classify always --all";
      ll = "eza --icons always --git --long";
      tree = "eza --icons always --classify always --tree";
      cat = "bat";
      grep = "rg";
      du = "dust";
      df = "duf";
      ps = "procs";
      top = "btm";
      diff = "delta";
      find = "fd";
      vim = "nix run 'github:T4D4-IU/mynixvim'";
      lg = "lazygit";
      dfx = "nix run 'github:T4D4-IU/dotfiles#dfx'";
      haystack-editor = "nix run 'github:T4D4-IU/dotfiles#haystack-editor'";
    };
  };
}
