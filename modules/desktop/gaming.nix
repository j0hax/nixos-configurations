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
  options.jka.desktop.gaming = {
    enable = lib.mkEnableOption "gaming packages and Steam";
  };

  config = lib.mkIf (cfg.enable && cfg.gaming.enable) {
    programs.steam.enable = true;

    boot.kernelModules = [ "ntsync" ];

    environment.systemPackages = with pkgs; [
      mindustry-wayland
      mumble
      supertux
      supertuxkart
      xonotic
      sauerbraten
      beyond-all-reason
      prismlauncher
      mangohud
    ];
  };
}
