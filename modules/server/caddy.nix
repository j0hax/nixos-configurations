{
  lib,
  pkgs,
  config,
  ...
}:
{
  services.caddy = {
    enable = true;
    email = "johannes@rnold.online";

    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddyserver/cache-handler@v0.16.0" ];
      hash = "sha256-aimkl2av4fyTXc8aSZx2onTzLmXAgk6VtgMkYtIuFLA=";
    };

    # Remove www subdomain
    /*
      virtualHosts."www.*".extraConfig = ''
        handle {
          redir https://{host[4:]}{uri}
        }
      '';

        TODO: Map virtualhosts attrs, filter by www.*, redirect to them
    */

    globalConfig = ''
      cache {
        ttl 1h
      }
    '';
  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [ 443 ];
  };
}
