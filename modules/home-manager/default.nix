{ pkgs, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.johannes = ({ pkgs, ...}:
  {
    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      arduino
    ark
    asciinema
    beats
    beets
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
    
    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ vim-nix ];
      extraConfig = ''
        set number
      '';
    };
  });
}
