{pkgs, ...}: {
  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-markdown-preview
      gh-copilot
      gh-dash
      gh-poi
      gh-actions-cache
      gh-eco
    ];
    settings = {
      editor = "vim";
      git_protocol = "ssh";
    };
  };
}
