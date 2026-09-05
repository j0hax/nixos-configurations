{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.jka.services.caddy;
in
{
  options.jka.services.caddy = {
    enable = lib.mkEnableOption "Caddy reverse proxy";

    email = lib.mkOption {
      type = lib.types.str;
      default = "johannes@rnold.online";
      description = "ACME email for Caddy.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;
      inherit (cfg) email;
    };

    networking.firewall = {
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [ 443 ];
    };
  };
}
