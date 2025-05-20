{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "johannes";
  home.homeDirectory = "/home/johannes";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs = {
    git = {
      enable = true;
      package = pkgs.gitFull;

      userName = "Johannes Arnold";
      userEmail = "jarnold@b1-systems.de";
      signing = {
        format = "openpgp";
        key = "F4CA40CF51CFB63F33EB0FCC91192A6AA8C42BFA";
        signByDefault = true;
      };

      delta.enable = true;
    };

    fish = {
      enable = true;
      functions.fish_greeting = "${lib.getExe pkgs.fortune-kind}";
    };

    helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "base16_terminal";
        editor = {
          cursorline = true;
          rulers = [
            80
            132
          ];
          bufferline = "always";
          popup-border = "all";
          inline-diagnostics = {
            cursor-line = "hint";
          };
        };
      };
    };

    mpv = {
      enable = true;
      config = {
        save-position-on-quit = "yes";
        profile = "gpu-hq";
        vo = "gpu-next";
        hwdec = "auto";
        slang = "en";
        cache = "yes";
        #cache-secs=10";
        demuxer-hysteresis-secs = "10";
        #Interpolation
        video-sync = "display-resample";
        interpolation = "yes";
      };
    };
  };
}
