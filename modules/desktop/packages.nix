{
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
    kepubify
    xournalpp
    prusa-slicer
    speedtest-cli
    imagemagick
    bitwarden-desktop
    spotify
    signal-desktop
    backgroundremover
    /*
      Although we use PipeWire,
      this is still needed for userspace
      configuration, especially for loading
      RAOP modules:
      pulseaudio
      pavucontrol
    */
    kdePackages.kdenlive
    virt-viewer
    languagetool
    libva-utils
    pdfpc
    gnome-network-displays
  ];

  programs = {
    localsend.enable = true;
    ausweisapp.enable = true;
    thunderbird.enable = true;
    chromium.enable = true;
    adb.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };

    obs-studio.enable = true;
  };

  # Enable Logitech devices
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };
}
