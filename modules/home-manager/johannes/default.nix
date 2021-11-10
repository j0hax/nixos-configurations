{ pkgs, ... }: {
  programs.home-manager.enable = true;

  xsession.enable = true;

  home.file.".face.icon".source = ./profile.jpg;

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
    hashcat
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
    pandoc
    pipes-rs
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
    ripgrep
    ventoy-bin
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

    rofi = { enable = true; };

    kitty.enable = true;

    bash.enable = true;

    atuin.enable = true;

    fzf = {
      enable = true;
      defaultOptions = [ "--preview 'bat --style=numbers --color=always {}'" ];
    };

    vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
        YouCompleteMe
        vim-gitgutter
        delimitMate
        vim-sensible
        vim-lastplace
      ];
      extraConfig = ''
        set number
        set tabstop=4
      '';
    };

    bat.enable = true;

    exa = {
      enable = true;
      enableAliases = true;
    };

    starship = {
      enable = true;
      settings = {
        username.show_always = true;
        battery.disabled = true;
        status.disabled = false;
      };
    };

    alacritty = {
      enable = true;
      settings = {
        background_opacity = 0.9;
      };
    };

    broot.enable = true;

    taskwarrior = { enable = true; };

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

  wayland.windowManager.sway = {
    enable = true;
    config = {
      #window.border = 0;
      modifier = "Mod4";
      terminal = "alacritty";
      input."*" = {
        xkb_layout = "us";
        xkb_variant = "altgr-intl";
      };
      output."*" =
        let
          randomBg = "find ~/Pictures/Wallpapers/ | shuf -n 1";
        in {
        bg = "\`${randomBg}\` fill";
      };
      gaps = {
        outer = 15;
        inner = 10;
      };
    };
  };

  # Keyboard configuration
  home.keyboard = {
    layout = "us";
    variant = "altgr-intl";
  };
}
