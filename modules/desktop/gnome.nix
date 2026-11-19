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
  options.jka.desktop.gnome = {
    enable = lib.mkEnableOption "GNOME desktop environment";
  };

  config = lib.mkIf (cfg.enable && cfg.gnome.enable) {
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    programs.kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };

    services.xrdp.enable = true;
    services.xrdp.defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";

    services.gnome.gnome-remote-desktop.enable = true;

    systemd.services.gnome-remote-desktop = {
      wantedBy = [ "graphical.target" ];
    };

    networking.firewall.allowedTCPPorts = [ 3389 ];

    services.displayManager.autoLogin.enable = false;
    services.getty.autologinUser = null;

    # GNOME applications are installed as user packages, see
    # modules/user/johannes/desktop.nix
  };
}
