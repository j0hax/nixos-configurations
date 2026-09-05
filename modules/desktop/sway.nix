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
  options.jka.desktop.sway = {
    enable = lib.mkEnableOption "Sway window manager";
  };

  config = lib.mkIf (cfg.enable && cfg.sway.enable) {
    services.gnome.gnome-keyring.enable = true;
    programs.light.enable = true;
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    environment.systemPackages = with pkgs; [
      grim
      slurp
      wl-clipboard
      mako
      gammastep
    ];
  };
}
