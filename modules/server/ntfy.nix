{ ... }:
let
  hostname = "ntfy.jka.one";
  port = 2586;
in
{
  imports = [ ./caddy.nix ];

  services.caddy.virtualHosts.${hostname}.extraConfig = ''
    reverse_proxy 127.0.0.1:${toString port}
  '';

  networking.firewall.allowedTCPPorts = [ 25 ];

  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://${hostname}";
      listen-http = ":${toString port}";
      behind-proxy = true;
      # auth-default-access = "deny-all";

      # E-Mail Settings
      smtp-server-listen = ":25";
      smtp-server-domain = hostname;
    };
  };
}
