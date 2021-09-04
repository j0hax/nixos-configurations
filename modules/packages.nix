{ config, pkgs, ... }: {
  # Base packages for desktop usage
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    archivebox
    arduino
    ark
    asciinema
    bat
    beats
    beets
    black
    bottom
    cava
    cmatrix
    discord
    exa
    file
    firefox
    gimp
    git
    gwenview
    htop
    imagemagick
    jq
    kate
    killall
    libreoffice-qt
    logitech-udev-rules
    magic-wormhole
    megatools
    mpv
    ncat
    neochat
    neofetch
    nixpkgs-fmt
    nixpkgs-review
    okular
    onefetch
    openscad
    parallel
    pipes
    plasma-systemmonitor
    prusa-slicer
    python3
    restic
    shellcheck
    shfmt
    skype
    sox
    spotify
    starship
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
    wget
    wineWowPackages.staging
    yakuake
    youtube-dl
    ytmdl
  ];

  # Certain programs
  programs.vim.defaultEditor = true;
  programs.java.enable = true;
  programs.adb.enable = true;
  programs.thefuck.enable = true;
  programs.steam.enable = true;
  programs.tmux.enable = true;
  programs.gnupg.agent.enable = true;
  programs.iftop.enable = true;
  programs.tilp2.enable = true;
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark-qt;
  };

  # Enable firmware updates
  services.fwupd.enable = true;

  # Some eyecandy
  programs.bash.promptInit = ''eval "$(starship init bash)"'';
  environment.shellAliases = {
    "cat" = "${pkgs.bat}/bin/bat";
    "ls" = "${pkgs.exa}/bin/exa";
  };
  environment.variables."MANPAGER" = "sh -c 'col -bx | bat -l man -p'";
}
