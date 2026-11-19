{
  lib,
  config,
  ...
}:
let
  cfg = config.jka.desktop;
in
{
  options.jka.desktop.plasma = {
    enable = lib.mkEnableOption "KDE Plasma desktop environment";
  };

  config = lib.mkIf (cfg.enable && cfg.plasma.enable) {
    services = {
      displayManager.plasma-login-manager.enable = true;
      desktopManager.plasma6.enable = true;
    };

    programs.kdeconnect.enable = true;

    # Plasma applications are installed as user packages, see
    # modules/user/johannes/desktop.nix
  };
}
