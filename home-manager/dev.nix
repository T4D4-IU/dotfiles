{pkgs, ...}: {
  home.packages = with pkgs; [
    marp-cli
    textlint
    zizmor # static analysis tool for GitHub Actions
    valgrind # memory leak detector
    act # GitHub Actionsのローカル実行
    pinact # Pin GitHub Actions versions
    actionlint # Static checker for GitHub Actions workflow files
  ];
}
