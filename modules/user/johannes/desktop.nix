{
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  cfg = osConfig.jka.desktop;
  graphical = cfg.packages.enable;
in
{
  home.packages =
    lib.optionals graphical (
      with pkgs;
      [
        # Shell helpers
        btop
        lnav
        ncdu
        tree

        # Media and graphics
        gimp
        imagemagick
        inkscape
        mpv
        signal-desktop
        dino
        speedtest-cli
        libva-utils
        mat2
        gramps
        pwsafe

        # Documents and writing
        libreoffice
        texlive.combined.scheme-full
        texmaker
        tectonic
        pandoc
        typst
        typstyle
        tinymist
        languagetool
        pdfpc
        foliate

        # Utilities
        aria2
        unzip
        wl-clipboard
        xournalpp
        just
        android-tools
        virt-viewer
        gnome-network-displays

        # 3D printing
        prusa-slicer
        openscad-unstable
        kepubify

        # Useless must-haves
        cbonsai
        cmatrix
        pipes-rs
        tty-clock
        fastfetch
      ]
      # Not available for aarch64-linux
      ++ lib.optionals (pkgs.stdenv.hostPlatform.isx86_64 && pkgs.stdenv.hostPlatform.isLinux) [
        spotify
      ]
    )
    ++ lib.optionals (graphical && cfg.packages.gnome) (
      with pkgs;
      [
        file-roller
        transmission_4-gtk
        apostrophe
        impression
        gnome-decoder
        metadata-cleaner
        gnome-obfuscate
        eyedropper
        shortwave
        video-trimmer
        varia
        gnome-2048
        gnome-firmware
        gnome-solanum
        crosspipe
        fractal
        gradia
        quadrapassel
        unstable.typesetter
      ]
    )
    ++ lib.optionals (graphical && cfg.packages.plasma) (
      with pkgs;
      (with kdePackages; [
        yakuake
        kcalc
        kclock
        ksystemlog
        kcolorchooser
        kolourpaint
      ])
      ++ [ transmission_4-qt ]
    )
    ++ lib.optionals (graphical && cfg.packages.sway) (
      with pkgs;
      [
        grim
        slurp
        mako
        gammastep
      ]
    )
    ++ lib.optionals (graphical && cfg.packages.gaming) (
      with pkgs;
      [
        mindustry-wayland
        mumble
        supertux
        supertuxkart
        prismlauncher
        mangohud
      ]
    );
}
