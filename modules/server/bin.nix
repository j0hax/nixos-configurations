{ config, ... }:
let
  port = 8153;
  host = "bin.jka.one";
in
{
  imports = [ ./caddy.nix ];

  services.caddy.virtualHosts.${host}.extraConfig = ''
    encode zstd gzip
    header X-Robots-Tag "noindex, nofollow"
    reverse_proxy 127.0.0.1:${toString port}
  '';

  services.microbin = {
    enable = true;
    settings = {
      MICROBIN_PORT = port;
      MICROBIN_HASH_IDS = true;
      MICROBIN_HIGHLIGHTSYNTAX = true;
      MICROBIN_PUBLIC_PATH = "https://${host}";
      MICROBIN_ENABLE_READONLY = true;
      MICROBIN_QR = true;
      MICROBIN_ENCRYPTION_CLIENT_SIDE = true;
      MICROBIN_ENCRYPTION_SERVER_SIDE = true;
      MICROBIN_FOOTER_TEXT = "<b><i>Tünn</i></b> (n): low german for bin.";
      MICROBIN_SHOW_READ_STATS = true;
      MICROBIN_EDITABLE = true;
    };
  };
}
