{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wl-clipboard
    gimp3
    sshuttle
    aria2
    inkscape
    openscad-unstable
    typst
    typstyle
    shellcheck
    shellfmt
  ];

  programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-backgroundremoval
        obs-pipewire-audio-capture
        input-overlay
        obs-vaapi
      ];
    };
}
