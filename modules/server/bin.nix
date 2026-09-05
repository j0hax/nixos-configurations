{
  lib,
  config,
  ...
}:
let
  cfg = config.jka.services.bin;
in
{
  options.jka.services.bin = {
    enable = lib.mkEnableOption "Microbin pastebin";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "bin.jka.one";
      description = "Domain for the pastebin service.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8153;
      description = "Internal port for Microbin.";
    };
  };

  config = lib.mkIf cfg.enable {
    jka.services.caddy.enable = true;

    services.caddy.virtualHosts.${cfg.domain}.extraConfig = ''
      encode zstd gzip
      header X-Robots-Tag "noindex, nofollow"
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';

    services.microbin = {
      enable = true;
      settings = {
        MICROBIN_PORT = cfg.port;
        MICROBIN_HASH_IDS = true;
        MICROBIN_HIGHLIGHTSYNTAX = true;
        MICROBIN_PUBLIC_PATH = "https://${cfg.domain}";
        MICROBIN_ENABLE_READONLY = true;
        MICROBIN_QR = true;
        MICROBIN_ENCRYPTION_CLIENT_SIDE = true;
        MICROBIN_ENCRYPTION_SERVER_SIDE = true;
        MICROBIN_FOOTER_TEXT = "<b><i>Tunn</i></b> (n): low german for bin.";
        MICROBIN_SHOW_READ_STATS = true;
        MICROBIN_EDITABLE = true;
      };
    };
  };
}
