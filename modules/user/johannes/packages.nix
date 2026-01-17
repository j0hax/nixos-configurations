{ pkgs, ... }:
{
  programs = {
    bat.enable = true;

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
    beets = {
      enable = true;
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
