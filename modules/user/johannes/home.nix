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

  imports = [
    ./packages.nix
    # Hyprland is a whole beast in itself.
    ./hyprland.nix
  ];

  # Set GNOME keyboard layout
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      show-all-sources = true;
      sources = [
        (lib.hm.gvariant.mkTuple [
          "xkb"
          "eu"
        ])
      ];
      xkb-options = "";
    };

    "org/gnome/desktop/interface" = {
      accent-color = "green";
      color-scheme = "prefer-dark";
    };
  };

  services = {
    spotifyd = {
      enable = true;
      settings = {
        no_audio_cache = true;
        audio_format = "F32";
        bitrate = 320;
      };
    };
  };

  programs = {
    git = {
      enable = true;
      package = pkgs.gitFull;

      userName = "Johannes Arnold";
      userEmail = "jarnold@b1-systems.de";

      extraConfig = {
        push.autoSetupRemote = true;
        init.defaultBranch = "main";
      };

      signing = {
        format = "openpgp";
        key = "F4CA40CF51CFB63F33EB0FCC91192A6AA8C42BFA";
        signByDefault = true;
      };

      delta = {
        enable = true;
        options = {
          mode = "diff-so-fancy";
          side-by-side = true;
        };
      };
    };

    gpg.enable = true;

    fish = {
      enable = true;
      functions.fish_greeting = ''
        ${lib.getExe pkgs.fortune-kind}
        ${lib.getExe config.programs.taskwarrior.package} ready limit:5
      '';
    };

    starship = {
      enable = true;
      settings = {
        line_break.disabled = true;
      };
    };

    firefox = {
      enable = true;
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DontCheckDefaultBrowser = true;
        DisablePocket = true;
        NoDefaultBookmarks = true;

        # Disable Sponsors
        FirefoxSuggest.SponsoredSuggestions = false;
        FirefoxHome.SponsoredTopSites = false;
      };
    };

    helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "gruvbox";
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

          soft-wrap.enable = true;
        };
      };
      languages = {
        language = [
          {
            name = "salt";
            scope = "source.yaml.salt";
            injection-regex = "sls";
            block-comment-tokens = [
              {
                start = "{{";
                end = "}}";
              }
              {
                start = "{%";
                end = "%}";
              }
              {
                start = "{#";
                end = "#}";
              }
            ];
            file-types = [ "sls" ];
            grammar = "yaml";
            indent = {
              tab-width = 2;
              unit = "  ";
            };
            language-servers = [ "salt-lint" ];
          }
        ];
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
