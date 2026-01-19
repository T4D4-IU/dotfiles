{
  home = rec {
    username="t4d4";
    homeDirectory = "/home/${username}";
    stateVersion = "22.11";
  };
  programs.home-manager.enable = true;
}
