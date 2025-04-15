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
    qidi-slicer-bin
    openscad-unstable
    monero-gui
    speedtest-cli
    imagemagick
    bitwarden-desktop
    signal-desktop
    mindustry-wayland

    /*
      Although we use PipeWire,
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
    firefox = {
      enable = true;
      package = pkgs.librewolf;
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        Preferences = {
          "cookiebanners.service.mode.privateBrowsing" = 2; # Block cookie banners in private browsing
          "cookiebanners.service.mode" = 2; # Block cookie banners
          "privacy.donottrackheader.enabled" = true;
          "privacy.fingerprintingProtection" = true;
          "privacy.resistFingerprinting" = true;
          "privacy.trackingprotection.emailtracking.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.fingerprinting.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
        };
        ExtensionSettings = {
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };
    };
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
