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
    # Useless must-haves
    environment.systemPackages = with pkgs; [
      cbonsai
      cmatrix
      pipes-rs
      tty-clock
      fastfetch
    ];
  };
}
