{ config, pkgs, ... }:
{
  # Base packages for desktop usage
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    ark
    asciinema
    bastet
    bat
    beets
    black
    brave
    cava
    cmatrix
    cool-retro-term
    discord
    exa
    file
    firefox
    gimp
    git
    gnupg
    gwenview
    htop
    imagemagick
    k3b
    kate
    killall
    libreoffice-qt
    logitech-udev-rules
    magic-wormhole
    minecraft
    mpv
    ncat
    neofetch
    nixpkgs-fmt
    okular
    onefetch
    openscad
    parallel
    pipes
    plasma-systemmonitor
    prusa-slicer
    python3
    restic
    skype
    solaar
    sox
    spotify
    starship
    texlive.combined.scheme-full
    texmaker
    thunderbird
    tldr
    transmission-qt
    tty-clock
    unrar
    vscodium
    wget
    whatsapp-for-linux
    wineWowPackages.staging
    yakuake
    youtube-dl
  ];

  # Certain programs
  programs.vim.defaultEditor = true;
  programs.java.enable = true;
  programs.adb.enable = true;
  programs.thefuck.enable = true;
  programs.steam.enable = true;
  programs.tmux.enable = true;

  # Some eyecandy
  programs.bash.promptInit = ''eval "$(starship init bash)"'';
  environment.shellAliases = { "cat" = "bat"; "ls" = "exa"; };
}
