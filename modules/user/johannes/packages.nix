{ pkgs, osConfig, ... }:
let
  isGraphical = osConfig.services.displayManager.enable;
in
{
  programs = {
    bat = {
      enable = true;
      config = {
        style = "plain";
        paging = "never";
      };
    };

    numbat.enable = true;

    eza.enable = true;

    taskwarrior = {
      enable = true;
      package = pkgs.taskwarrior3;
    };
    /*
      obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          #obs-backgroundremoval
          obs-pipewire-audio-capture
          input-overlay
          obs-vaapi
        ];
      };
    */

    firefox = {
      enable = isGraphical;
      policies = {
        BlockAboutConfig = true;
        CaptivePortal = true;

        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DontCheckDefaultBrowser = true;
        DisablePocket = true;
        NoDefaultBookmarks = true;

        # Disable unecessary features
        PasswordManagerEnabled = false;
        GenerativeAI = {
          Enabled = false;
        };

        # Disable Sponsors
        FirefoxSuggest.SponsoredSuggestions = false;
        FirefoxHome = {
          SponsoredTopSites = false;
          SponsoredPocket = false;
          SponsoredStories = false;
        };
      };
    };

    mpv = {
      enable = isGraphical;
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
      enable = isGraphical;
      settings = {
        # output = "\"%(uploader)s/%(title)s [%(id)s].%(ext)s\"";
        output = "\"%(title)s [%(id)s].%(ext)s\"";
        download-archive = "\"archive.dat\"";
        paths = "temp:/var/tmp/yt-dlp"; # "temp:/tmp/yt-dlp";
        embed-thumbnail = true;
        embed-metadata = true;
        embed-subs = true;
        sub-langs = "all";
        sponsorblock-remove = "sponsor";
      };
    };

    beets = {
      enable = false;
      settings = {
        directory = "/media/nextcloud/Music/";
        import = {
          move = true;
          from_scratch = true;
        };

        plugins = [
          "fetchart"
          "embedart"
          "lastgenre"
          "scrub"
          "missing"
        ];
      };
    };

    foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          include = "~/.config/foot/themes/noctalia";
          font = "Iosevka Term:size=12";
          pad = "12x12 center";
          # Compatability
          term = "xterm-256color";
        };
        bell = {
          notify = true;
          visual = true;
        };
        cursor = {
          style = "underline";
          blink = true;
        };
      };
    };
  };
}
