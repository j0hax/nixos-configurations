{
  config,
  pkgs,
  ...
}:
let
  fraunhofer = (
    pkgs.ffmpeg.override {
      withUnfree = true;
      withFdkAac = true;
    }
  );
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
  };

  environment.systemPackages = with pkgs; [
    ripgrep
    nix-output-monitor
    tree
    yt-dlp
    rclone

    bc
    pwsafe

    fraunhofer
    (beets.override { ffmpeg = fraunhofer; })
  ];
}
