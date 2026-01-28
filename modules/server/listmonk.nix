{ pkgs, ... }:
let
  hostname = "lists.test.avfrisia.de";
  port = 9000;
in
{
  imports = [ ./caddy.nix ];

  services.caddy.virtualHosts.${hostname}.extraConfig = ''
    reverse_proxy 127.0.0.1:${toString port}
  '';

  /*
    services.listmonk = {
      enable = true;
      package = (pkgs.listmonk.override {
        hash = "sha256-FUhmbp4P9zQFlSf3ss17zs4ZaPUi0CbVceq3ZJeIXBY=";
      });
    };
  */
}
