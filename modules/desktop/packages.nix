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
    mat2
    imagemagick
    bitwarden-desktop
    spotify
    signal-desktop
    backgroundremover
    openscad-unstable
    aria2
    inkscape
    pandoc
    just
    typst
    typstyle
    tinymist
    shellcheck
    shfmt
    wl-clipboard
    unzip
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
    dino
    android-tools
  ];

  programs = {
    localsend.enable = true;
    ausweisapp.enable = true;
    thunderbird.enable = true;
    chromium.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
    wireshark.enable = true;
    obs-studio.enable = true;
  };

  # Enable Logitech devices
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };
}
