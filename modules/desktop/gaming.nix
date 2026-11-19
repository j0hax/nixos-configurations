{
  lib,
  config,
  ...
}:
let
  cfg = config.jka.desktop;
in
{
  options.jka.desktop.gaming = {
    enable = lib.mkEnableOption "gaming packages and Steam";
  };

  config = lib.mkIf (cfg.enable && cfg.gaming.enable) {
    programs.steam.enable = true;

    # Steam and Wine need a graphics driver with 32-bit userspace support
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    boot.kernelModules = [ "ntsync" ];

    # Games are installed as user packages, see
    # modules/user/johannes/desktop.nix
  };
}
