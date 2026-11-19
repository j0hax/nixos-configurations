{
  lib,
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

    # Sway utilities are installed as user packages, see
    # modules/user/johannes/desktop.nix
  };
}
