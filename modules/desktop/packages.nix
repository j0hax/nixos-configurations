{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.jka.desktop;
in
{
  config = lib.mkIf cfg.enable {
    # Codec support for video and audio playback, the mpv frontend lives in
    # the user profile (modules/user/johannes/desktop.nix)
    environment.systemPackages = [ pkgs.mpv ];

    # Run Windows programs natively
    boot.binfmt.emulatedSystems = [
      "x86_64-windows"
      "i686-windows"
    ];

    programs = {
      localsend.enable = true;
      ausweisapp.enable = true;
      thunderbird.enable = true;
      chromium.enable = true;
      appimage = {
        enable = true;
        binfmt = true;
      };
      # obs-studio.enable = true;
      wavemon.enable = true;
      ydotool.enable = true;
    };
  };
}
