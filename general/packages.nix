{ config, pkgs, ... }:
{
  # Base packages for desktop usage
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    brave
    okular
    mpv
    vscodium
    firefox
    kate
    imagemagick
    openscad
    discord
    youtube-dl
    prusa-slicer
    thunderbird
    ark
    git
    spotify
    solaar
    logitech-udev-rules
    yakuake
    gwenview
    k3b
    texlive.combined.scheme-full
    texmaker
    restic
    transmission-qt
    black
    beets
    magic-wormhole
    cool-retro-term
    cmatrix
    htop
    neofetch
    pipes
    nixpkgs-fmt
    starship
    bat
    minecraft
    cava
    tty-clock
    plasma-systemmonitor
    python3
    gimp
    wget
    sox
    unrar
    bastet
    exa
    libreoffice-qt
    file
    killall
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
