{ pkgs, ... }: {
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    arduino
    ark
    asciinema
    beats
    black
    bottom
    cava
    cmatrix
    discord
    firefox
    gimp
    gwenview
    htop
    hydra-check
    imagemagick
    jq
    kate
    libreoffice-qt
    magic-wormhole
    megatools
    mpv
    ncat
    neochat
    neofetch
    nixfmt
    nixpkgs-review
    octaveFull
    okular
    onefetch
    openscad
    pipes
    plasma-systemmonitor
    prusa-slicer
    qrcp
    shellcheck
    shfmt
    skype
    sox
    spotify
    taskwarrior
    texlive.combined.scheme-full
    texmaker
    thunderbird
    tor-browser-bundle-bin
    transmission-qt
    tty-clock
    unrar
    usbutils
    vscodium
    yakuake
    youtube-dl
    ytmdl
  ];

  programs = {
    vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ vim-nix ];
      extraConfig = ''
        set number
      '';
    };

    beets = {
      enable = true;
      config = {
        directory = "/data/music/";
        library = "/data/music/library.db";
        threaded = "yes";
        import = {
          write = "yes";
          move = "yes";
        };
        plugins = [ "info" "fetchart" "embedart" "lastgenre" "missing" "chroma" "scrub" "discogs" "convert" ];
      };
    };
  };
}
