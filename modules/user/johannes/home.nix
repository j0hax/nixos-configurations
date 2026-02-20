{
  config,
  osConfig,
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
  ];

  dconf.settings = lib.mkIf (osConfig.services.desktopManager.gnome.enable) {
    # Set GNOME keyboard layout
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

    # For gaming on the go
    "org/gnome/desktop/peripherals/touchpad" = {
      disable-while-typing = false;
    };

    # Vanilla tweaks
    "org/gnome/desktop/interface" = {
      accent-color = "green";
      color-scheme = "prefer-dark";
      clock-show-seconds = true;
      clock-show-date = false;
      clock-show-weekday = false;
    };

    "org/gnome/desktop/datetime" = {
      automatic-timezone = true;
    };

    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };

    "org/gnome/system/location" = {
      enabled = true;
    };

    "org/gnome/Console" = {
      transparency = true;
    };
  };

  services = {
    ssh-agent.enable = true;
  };

  home.shellAliases = {
    cat = "bat";
    ls = "eza";
  };

  programs = {
    git = {
      enable = true;
      package = pkgs.gitFull;

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
          # Possibly dangerous
          rebase = true;
          autostash = true;
        };

        init.defaultBranch = "main";
        credential.helper = "/etc/profiles/per-user/johannes/bin/git-credential-libsecret";
        maintenance.enable = true;

        signing = {
          format = "openpgp";
          key = "F4CA40CF51CFB63F33EB0FCC91192A6AA8C42BFA";
          signByDefault = true;
        };
      };
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        mode = "diff-so-fancy";
        side-by-side = true;
      };
    };

    gpg.enable = true;

    fish = {
      enable = true;
      functions.fish_greeting = ''
        ${lib.getExe pkgs.fortune-kind}
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
          indent-guides = {
            render = true;
            skip-levels = 1;
          };
          whitespace.characters = {
            space = "·";
            nbsp = "⍽";
            nnbsp = "␣";
            tab = "→";
            newline = "⏎";
            tabpad = "·";
          };
          bufferline = "always";
          popup-border = "all";
          inline-diagnostics = {
            cursor-line = "hint";
          };

          soft-wrap.enable = true;
        };
      };
      languages = {
        language-server = {
          harper-ls = {
            command = "harper-ls";
            args = [ "--stdio" ];
          };
        };

        language = [
          {
            name = "markdown";
            language-servers = [
              "marksman"
              "markdown-oxide"
              "harper-ls"
            ];
          }
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

  };
}
