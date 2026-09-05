{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.jka.desktop;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mpv
      libreoffice
      texlive.combined.scheme-full
      texmaker
      tectonic
      chromium
      gimp
      kepubify
      xournalpp
      prusa-slicer
      speedtest-cli
      mat2
      imagemagick
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
      pwsafe
      shellcheck
      shfmt
      wl-clipboard
      gramps
      unzip
      virt-viewer
      languagetool
      libva-utils
      pdfpc
      gnome-network-displays
      dino
      android-tools
    ];

    # Run Windows programs natively
    boot.binfmt.emulatedSystems = [
      "x86_64-windows"
      "i686-windows"
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
      obs-studio.enable = true;
      wavemon.enable = true;
      ydotool.enable = true;
    };

    # Enable Logitech devices
    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };
}
