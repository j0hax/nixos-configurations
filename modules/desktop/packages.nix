{
  config,
  pkgs,
  ...
}:
{
  # Generic GUI packages
  environment.systemPackages = with pkgs; [
    mpv
    libreoffice
    texlive.combined.scheme-full
    texmaker
    tectonic
    handbrake
    chromium
    signal-desktop
    kepubify
    xournalpp
    qidi-slicer-bin

    /* Although we use PipeWire,
       this is still needed for userspace
       configuration, especially for loading
       RAOP modules.
    */
    pulseaudio
    pavucontrol

    libva-utils
  ];

  programs = {
    localsend.enable = true;
    ausweisapp.enable = true;
    thunderbird.enable = true;
    firefox.enable = true;
    steam.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
