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
    #openscad-unstable
    monero-gui
    speedtest-cli
    imagemagick
    bitwarden-desktop
    signal-desktop
    mindustry-wayland
    freecad-wayland

    /*
      Although we use PipeWire,
      this is still needed for userspace
      configuration, especially for loading
      RAOP modules.
    */
    pulseaudio
    pavucontrol

    libva-utils

    kicad
    prismlauncher
  ];

  programs = {
    localsend.enable = true;
    ausweisapp.enable = true;
    thunderbird.enable = true;
    chromium.enable = true;
    steam.enable = true;
    adb.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
  };

  # Enable Logitech devices
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };
}
