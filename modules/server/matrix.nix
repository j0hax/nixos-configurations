{ config, ... }:
let
  domain = config.networking.domain;
  matrixDomain = "matrix.${config.networking.domain}";
  port = toString config.services.matrix-tuwunel.settings.global.port;
in
{
  imports = [ ./caddy.nix ];

  services.caddy.virtualHosts = {
    ${domain} = {
      serverAliases = [ "${domain}:8448" ];
      extraConfig = ''
        handle /.well-known/* {
          header /.well-known/matrix/* Content-Type application/json
          header /.well-known/matrix/* Access-Control-Allow-Origin *
          respond /.well-known/matrix/server `{"m.server": "${matrixDomain}:443"}`
          respond /.well-known/matrix/client `{"m.homeserver":{"base_url":"https://${matrixDomain}"}}`
        }

        # Redirect anything else to homepage.
        handle {
          redir https://johannes-arnold.de{uri}
        }
      '';
    };

    ${matrixDomain} = {
      extraConfig = ''
        reverse_proxy /_matrix/* 127.0.0.1:${port}
        reverse_proxy /_synapse/client/* 127.0.0.1${port}
        encode zstd gzip
        header X-Robots-Tag "noindex, nofollow"
      '';
    };

  };

  networking.firewall = {
    allowedTCPPorts = [ 8448 ];
    allowedUDPPorts = [ 8448 ];
  };

  services.matrix-tuwunel = {
    enable = true;
    settings = {
      global = {
        server_name = domain;
        allow_registration = true;
        trusted_servers = [
          "matrix.org"
          "matrix.uni-hannover.de"
        ];
        registration_token = "Vo2ish5d";
        well_known = {
          client = "https://${matrixDomain}";
          server = "${matrixDomain}:443";
        };
      };
    };
  };
}
