{ lib, config, ... }:
{
  services.caddy = lib.mkDefault {
    enable = true;
    email = "johannes@rnold.online";
    globalConfig = ''
      encode zstd gzip
      header {
        X-Clacks-Overhead GNU Ozzy Osbourne
      }
    '';

    # Remove www subdomain
    virtualHosts."www.${config.networking.fqdn}".extraConfig = ''
      redir https://example.com{uri}
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
