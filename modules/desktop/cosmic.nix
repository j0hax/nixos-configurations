{
  lib,
  config,
  ...
}:
let
  cfg = config.jka.desktop;
in
{
  options.jka.desktop.cosmic = {
    enable = lib.mkEnableOption "COSMIC desktop environment";
  };

  config = lib.mkIf (cfg.enable && cfg.cosmic.enable) {
    services = {
      desktopManager.cosmic = {
        enable = true;
        xwayland.enable = true;
      };
      displayManager.cosmic-greeter.enable = true;
    };
  };
}
