{config, ...}: {
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = config.home.username;
        email = "t4d4.icp@gmail.com";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      core = {
        editor = "vim";
        autocrlf = "input";
      };

      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      light = false;
      side-by-side = true;
    };
  };
}
