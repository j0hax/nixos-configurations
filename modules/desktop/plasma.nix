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
  options.jka.desktop.plasma = {
    enable = lib.mkEnableOption "KDE Plasma desktop environment";
  };

  config = lib.mkIf (cfg.enable && cfg.plasma.enable) {
    services = {
      displayManager.plasma-login-manager.enable = true;
      desktopManager.plasma6.enable = true;
    };

    environment.systemPackages =
      with pkgs.kdePackages;
      [
        yakuake
        kcalc
        kclock
        ksystemlog
        kcolorchooser
        kolourpaint
      ]
      ++ (with pkgs; [
        transmission_4-qt
      ]);

    programs.kdeconnect.enable = true;
  };
}
