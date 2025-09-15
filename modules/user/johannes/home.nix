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
    ssh-agent.enable = true;
    spotifyd = {
      enable = true;
      settings.global = {
        no_audio_cache = false;
        backend = "pulseaudio";
        initial_volume = 30;

        # Maximum quality settings:
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

      aliases = {
        afp = "!git commit -a --amend --no-edit && git push --force";
        diff-staged = "diff --cached";
        last = "log -1 HEAD --stat";
        ac = "commit -a";
        acm = "commit -a -m";
        d = "diff";
        pa = "push --all";
      };

      extraConfig = {
        checkout.workers = -1;
        push.autoSetupRemote = true;
        fetch = {
          prune = true;
          pruneTags = true;
        };

        pull = {
          # Possibly dangerous
          #rebase = true;
          autostash = true;
        };
        
        init.defaultBranch = "main";
        credential.helper = "/etc/profiles/per-user/johannes/bin/git-credential-libsecret";
        maintenance.enable = true;
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
        time = {
          disabled = false;
          format = "[\\[$time\\]]($style)";
          time_format = "%R";
        };
        right_format = "$time";
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

    yt-dlp = {
      enable = true;
      settings = {
        output = "\"%(uploader)s/%(title)s [%(id)s].%(ext)s\"";
        download-archive = "\"yt-dlp_archive.dat\"";
        paths = "temp:/var/tmp/yt-dlp"; # "temp:/tmp/yt-dlp";
        embed-thumbnail = true;
        embed-metadata = true;
        embed-subs = true;
        sub-langs = "all";
        sponsorblock-remove = "sponsor";
      };
    };
  };
}
