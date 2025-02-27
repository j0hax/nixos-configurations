{
  pkgs,
  config,
  ...
}:
let
  ffmpeg-package = pkgs.ffmpeg-full;
in
{
  # Kinda cringe :(
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  # Useful system-wide tools to enable
  programs = {
    htop.enable = true;
    iotop.enable = true;
    iftop.enable = true;
    tcpdump.enable = true;
    tmux.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
    };
    fish = {
      enable = true;
      useBabelfish = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
    ccache.enable = true;
    flashrom.enable = true;
    gnupg.agent.enable = true;
  };

  environment.systemPackages = with pkgs; [
    config.boot.kernelPackages.perf

    uutils-coreutils-noprefix
    ripgrep
    nix-output-monitor
    tree
    yt-dlp
    rclone
    mat2
    bc
    pwsafe
    file
    ffmpeg-package
    ncdu
    pv
    wget
    usbutils
  ];
}
