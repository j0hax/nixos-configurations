{ ... }:
{
  services.caddy = {
    enable = true;
    globalConfig = ''
      encode zstd gzip
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
