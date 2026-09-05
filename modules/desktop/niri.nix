{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.jka.desktop;
in
{
  imports = [
    inputs.noctalia.nixosModules.default
  ];

  options.jka.desktop.niri = {
    enable = lib.mkEnableOption "Niri compositor with Noctalia";
  };

  config = lib.mkIf (cfg.enable && cfg.niri.enable) {
    programs = {
      noctalia = {
        enable = true;
        recommendedServices.enable = true;
      };
      niri.enable = true;
      foot = {
        enable = true;
        settings = {
          main = {
            font = "Iosevka:size=16";
          };
        };
      };
      seahorse.enable = true;
    };

    services.gvfs.enable = true;

    environment.systemPackages = with pkgs; [
      ddcutil
      xwayland-satellite
      posy-cursors
      quickshell
      kdlfmt
      libnotify
      swww

      nautilus
      papers
      loupe
      file-roller
      adwaita-icon-theme
      transmission_4-gtk
    ];
  };
}
