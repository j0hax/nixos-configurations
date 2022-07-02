{ pkgs, lib, ... }: {
  home.stateVersion = "22.11";

  programs.home-manager.enable = lib.mkDefault true;

  xsession.enable = lib.mkDefault true;

  home.file.".face.icon".source = ./profile.jpg;

  home.packages = with pkgs; [
    arduino
    anki
    asciinema
    beats
    black
    bottom
    cava
    cmatrix
    discord
    firefox
    gimp
    htop
    logisim-evolution
    qrcp
    hydra-check
    imagemagick
    libreoffice-qt
    magic-wormhole
    megatools
    ffmpeg-full
    nmap
    neofetch
    nixfmt
    nixpkgs-review
    onefetch
    openscad
    pipes-rs
    prusa-slicer
    shellcheck
    shfmt
    skypeforlinux
    sox
    silicon
    sshuttle
    spotify
    pmbootstrap
    taskwarrior
    tectonic
    texmaker
    thunderbird
    tor-browser-bundle-bin
    tty-clock
    unrar
    tdesktop
    usbutils
    scanmem
    vscodium
    yt-dlp
    ytmdl
    ballerburg
    minecraft
    ripgrep
    hyperfine
    hexyl
    ventoy-bin
    speedcrunch
    whatsapp-for-linux
    (writeShellApplication {
      name = "cut-video";
      runtimeInputs = [ ffmpeg ];
      text = ''
        exec ffmpeg -y -i "$1" -ss "$2" -to "$3" "$(mktemp -t cut_XXX.mp4)"
      '';
    })

    # Simple tool to generate PDFs of source code
    (writeShellApplication {
      name = "codepdf";
      runtimeInputs = [ enscript ghostscript wkhtmltopdf ];
      text = ''
        bn=$(basename "$1")
        tmp=$(mktemp -t "XXX_$bn")
        iconv -f utf-8 -t iso-8859-1 "$1" -o "$tmp"
        enscript -q -G --color --line-numbers --highlight "$tmp" -o - | ps2pdf - code.pdf
      '';
    })

    # Gnome Apps to try out
    wike
    gnome-solanum
    shortwave
    foliate
    gnome-feeds
  ];

  home.shellAliases = {
    cat = "${pkgs.bat}/bin/bat";
    zathura = "zathura --fork";
  };

  programs = {
    jq.enable = lib.mkDefault true;

    go.enable = lib.mkDefault true;

    pandoc.enable = lib.mkDefault true;

    mangohud = {
      enable = lib.mkDefault true;
      enableSessionWide = lib.mkDefault true;
      settings = {
        cpu_temp = 1;
        gpu_temp = 1;
      };
    };

    rofi = { enable = lib.mkDefault true; };

    zsh = lib.mkDefault {
      enable = true;
      enableCompletion = true;
      autocd = true;
    };

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

    aria2 = {
      enable = true;
      settings = {
        summary-interval = 0;
        check-integrity = true;
        continue = true;
        max-connection-per-server = 16;
        disk-cache = "128M";
        file-allocation = "falloc";
      };
    };

    bat.enable = lib.mkDefault true;

    exa = {
      enable = lib.mkDefault true;
      enableAliases = lib.mkDefault true;
    };

    git = {
      enable = lib.mkDefault true;
      package = pkgs.gitAndTools.gitFull;
      lfs.enable = lib.mkDefault true;
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
        fetchart = { enforce_ratio = lib.mkDefault true; };
      };
    };

    obs-studio.enable = true;

    foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          term = "xterm-256color";
          pad = "16x16 center";
          font = "Iosevka:size=8";
        };
        mouse = { hide-when-typing = "yes"; };
      };
    };

    texlive = {
      enable = true;
      extraPackages = tpkgs: {
      inherit (tpkgs) scheme-full;
    };

    };

    mpv = {
      enable = true;
      config = {
        interpolation = true;
        tscale = "oversample";
        video-sync = "display-resample";
        sub-auto = "fuzzy";
        save-position-on-quit = true;
      };
      defaultProfiles = [ "gpu-hq" ];
    };

    zathura.enable = true;
  };

  wayland.windowManager.sway = {
    enable = lib.mkDefault true;
    config = {
      #window.border = 0;
      modifier = "Mod1";
      terminal = "footclient";
      input."*" = {
        xkb_layout = "us";
        xkb_variant = "altgr-intl";
      };
      output."*".bg = "#3a6ea5 solid_color";
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

  # Extra variables
  home.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
    MOZ_ENABLE_WAYLAND = 1;
  };
}
