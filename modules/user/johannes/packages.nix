{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wl-clipboard
    gimp3
    sshuttle
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
