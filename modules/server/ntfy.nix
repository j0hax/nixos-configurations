{
  lib,
  config,
  ...
}:
let
  cfg = config.jka.services.ntfy;
in
{
  options.jka.services.ntfy = {
    enable = lib.mkEnableOption "ntfy push notification server";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "ntfy.jka.one";
      description = "Domain for the ntfy server.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 2586;
      description = "Internal port for ntfy.";
    };
  };

  config = lib.mkIf cfg.enable {
    jka.services.caddy.enable = true;

    services.caddy.virtualHosts.${cfg.domain}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';

    networking.firewall.allowedTCPPorts = [ 25 ];

    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://${cfg.domain}";
        listen-http = ":${toString cfg.port}";
        behind-proxy = true;
        auth-default-access = "deny-all";
        auth-access = [
          "*:up*:write-only"
        ];
        smtp-server-listen = ":25";
        smtp-server-domain = cfg.domain;
      };
    };
  };
}
