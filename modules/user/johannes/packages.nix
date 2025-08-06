{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wl-clipboard
    logseq
    gimp3
    sshuttle
    aria2
    inkscape
    openscad-unstable
    godot

    typst
    typstyle
    tinymist

    shellcheck
    shfmt
  ];

  programs = {
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
  };
}
