{ lib, pkgs, ... }:
{
  services.caddy = {
    enable = true;
    virtualHosts."jellyfin.jka.one".extraConfig = ''
      reverse_proxy 127.0.0.1:8096
    '';
  };
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.jellyfin.enable = true;
}
