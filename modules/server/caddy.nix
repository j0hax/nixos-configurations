{ lib, config, ... }:
{
  services.caddy = {
    enable = true;
    email = "johannes@rnold.online";

    # Remove www subdomain
    virtualHosts."www.${config.networking.domain}".extraConfig = ''
      redir https://${config.networking.domain}{uri}
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
