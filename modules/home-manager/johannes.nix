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
    ballerburg
    minecraft
  ];

  programs = {
    jq.enable = true;

    mangohud = {
      enable = true;
      enableSessionWide = true;
      settings = {
        cpu_temp = 1;
        gpu_temp = 1;
      };
    };

    bash.enable = true;

    atuin.enable = true;

    vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ vim-nix ];
      extraConfig = ''
        set number
      '';
    };

    starship = {
      enable = true;
      settings = {
        username.show_always = true;
      };
    };

    taskwarrior = {
      enable = true;
    };

    beets = {
      enable = true;
      settings = {
        directory = "/data/music/";
        library = "/data/music/library.db";
        threaded = true;
        import = {
          write = true;
          move = true;
        };
        plugins = [
          "info"
          "fetchart"
          "embedart"
          "lastgenre"
          "missing"
          "chroma"
          "scrub"
          "discogs"
          "convert"
        ];
      };
    };
  };
}
