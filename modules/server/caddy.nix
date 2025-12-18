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

    # Remove www subdomain
    /*
      virtualHosts."www.*".extraConfig = ''
        handle {
          redir https://{host[4:]}{uri}
        }
      '';

        TODO: Map virtualhosts attrs, filter by www.*, redirect to them
    */

 };

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [ 443 ];
  };
}
