{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.jka.services.warpgate;
in
{
  options.jka.services.warpgate = {
    enable = lib.mkEnableOption "Warpgate Bastion";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "gate.jka.one";
      description = "Domain name for Warpgate";
    };

    httpPort = lib.mkOption {
      type = lib.types.port;
      default = 8888;
      description = "Port for HTTP Bastion";
    };

    sshPort = lib.mkOption {
      type = lib.types.port;
      default = 2222;
      description = "Port for SSH Bastion";
    };
  };

  config = lib.mkIf cfg.enable {
    jka.services.caddy.enable = true;

    services.caddy.virtualHosts.${cfg.domain} = {
      serverAliases = [ "*.${cfg.domain}" ];
      extraConfig = ''
        encode
        reverse_proxy https://127.0.0.1:8888 {
          transport http {
            tls_insecure_skip_verify
          }
        }
      '';
    };

    services.warpgate = {
      enable = true;
      package = pkgs.unstable.warpgate;
      settings = {
        external_host = cfg.domain;
        ssh = {
          enable = true;
          external_host = cfg.domain;
          external_port = cfg.sshPort;
        };
        http = {
          external_host = cfg.domain;
          external_port = 443;
          trust_x_forwarded_headers = true;
        };
      };
    };
  };
}
