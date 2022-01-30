{ pkgs, lib, ... }: {
  programs.home-manager.enable = lib.mkDefault true;

  xsession.enable = lib.mkDefault true;

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
    kronometer
    libreoffice-qt
    magic-wormhole
    megatools
    mpv
    ncat
    neochat
    neofetch
    nixfmt
    nixpkgs-review
    okular
    onefetch
    openscad
    pandoc
    pipes-rs
    plasma-systemmonitor
    prusa-slicer
    (qrcp.overrideAttrs (oldAttrs: rec {
      patches = [
        (fetchpatch {
          name = "env-variable-port.patch";
          url = "https://patch-diff.githubusercontent.com/raw/claudiodangelis/qrcp/pull/222.patch";
          sha256 = "sha256-+JkvmSv7sjmQC46dkcKOZjqjryte2uggXIy63v+vTFQ=";
        })
      ];
    }))
    shellcheck
    shfmt
    skype
    sox
    silicon
    sshuttle
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
    yt-dlp
    ytmdl
    ballerburg
    minecraft
    ripgrep
    hyperfine
    hexyl
    ventoy-bin
    speedcrunch
    simplescreenrecorder
    (writeShellScriptBin "cut-video" ''
      exec ${pkgs.ffmpeg}/bin/ffmpeg -y -i "$1" -ss $2 -to $3 $(mktemp -t cut_XXX.mp4)
    '')
    (writeShellScriptBin "merge-pdf" ''
      file=$(mktemp -t merged_XXX.pdf)
      ${pkgs.pdftk}/bin/pdftk $@ cat output $file
      echo "Written to $file"
    '')
  ];

  home.shellAliases = { cat = "${pkgs.bat}/bin/bat"; };

  programs = {
    jq.enable = lib.mkDefault true;

    mangohud = {
      enable = lib.mkDefault true;
      enableSessionWide = lib.mkDefault true;
      settings = {
        cpu_temp = 1;
        gpu_temp = 1;
      };
    };

    rofi = { enable = lib.mkDefault true; };

    kitty.enable = lib.mkDefault true;

    bash.enable = lib.mkDefault true;

    atuin.enable = lib.mkDefault true;

    fzf = {
      enable = lib.mkDefault true;
      defaultOptions = [ "--preview 'bat --style=numbers --color=always {}'" ];
    };

    neovim = {
      enable = lib.mkDefault true;
      viAlias = lib.mkDefault true;
      vimAlias = lib.mkDefault true;
      coc.enable = lib.mkDefault true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
        vim-gitgutter
        delimitMate
        vim-sensible
        vim-lastplace
      ];
      extraConfig = ''
        set number
        set tabstop=4
        set mouse=a
        highlight Comment cterm=italic gui=italic
      '';
    };

    bat.enable = lib.mkDefault true;

    exa = {
      enable = lib.mkDefault true;
      enableAliases = lib.mkDefault true;
    };

    starship = {
      enable = lib.mkDefault true;
      settings = {
        username.show_always = lib.mkDefault true;
        battery.disabled = lib.mkDefault true;
        status.disabled = false;
      };
    };

    alacritty = {
      enable = lib.mkDefault true;
      settings = {
        background_opacity = 0.9;
      };
    };

    git = {
      enable = lib.mkDefault true;
      delta.enable = lib.mkDefault true;
    };

    broot.enable = lib.mkDefault true;

    taskwarrior = { enable = lib.mkDefault true; };

    beets = {
      enable = lib.mkDefault true;
      settings = {
        directory = "/data/music/";
        library = "/data/music/library.db";
        threaded = lib.mkDefault true;
        bell = lib.mkDefault true;
        from_scratch = lib.mkDefault true;
        import = {
          write = lib.mkDefault true;
          move = lib.mkDefault true;
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
        fetchart = {
          enforce_ratio = lib.mkDefault true;
        };
      };
    };
  };

  wayland.windowManager.sway = {
    enable = lib.mkDefault true;
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
