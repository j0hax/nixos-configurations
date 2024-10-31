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

    flashrom.enable = true;
  };

  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    ripgrep
    nix-output-monitor
    tree
    yt-dlp

    pass
    pwsafe

    fraunhofer
    (beets.override { ffmpeg = fraunhofer; })
  ];
}
