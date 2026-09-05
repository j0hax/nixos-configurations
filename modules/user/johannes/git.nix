{
  pkgs,
  ...
}:
{
  programs = {
    git = {
      enable = true;
      package = pkgs.gitFull;

      signing = {
        format = "openpgp";
        key = "F4CA40CF51CFB63F33EB0FCC91192A6AA8C42BFA";
        signByDefault = true;
      };

      settings = {
        user = {
          name = "Johannes Arnold";
          email = "jarnold@b1-systems.de";
        };

        alias = {
          afp = "!git commit -a --amend --no-edit && git push --force";
          diff-staged = "diff --cached";
          last = "log -1 HEAD --stat";
          ac = "commit -a";
          acm = "commit -a -m";
          d = "diff";
          pa = "push --all";
        };

        checkout.workers = -1;
        push.autoSetupRemote = true;
        fetch = {
          prune = true;
          pruneTags = true;
        };

        pull = {
          rebase = true;
          autostash = true;
        };

        init.defaultBranch = "main";
        credential.helper = "/etc/profiles/per-user/johannes/bin/git-credential-libsecret";
        maintenance.enable = true;
      };
    };

    # Git diff viewer
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        mode = "diff-so-fancy";
        side-by-side = true;
      };
    };

    gpg.enable = true;
  };
}
