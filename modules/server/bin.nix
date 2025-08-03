{ config, ... }:
{
  imports = [ ./caddy.nix ];

  services.caddy.virtualHosts.${config.services.wastebin.settings.WASTEBIN_BASE_URL}.extraConfig = ''
    reverse_proxy ${config.services.wastebin.settings.WASTEBIN_ADDRESS_PORT}
    encode zstd gzip
    header X-Robots-Tag "noindex, nofollow"
    cache
  '';


  /*services.microbin = {
    enable = true;
    settings = {
      MICROBIN_PORT = 2345;
      # Plattdeutsch
      MICROBIN_TITLE = "De Tünn";
      MICROBIN_ENABLE_BURN_AFTER = true;
      MICROBIN_ENABLE_READONLY = true;
      MICROBIN_ENCRYPTION_CLIENT_SIDE = true;
      MICROBIN_ENCRYPTION_SERVER_SIDE = true;
      MICROBIN_HASH_IDS = true;
      MICROBIN_FOOTER_TEXT = "<b><i>Tünn</i></b> (n): low german for bin.";
    };
  };
  */

  services.wastebin = {
    enable = true;
    settings = {
      WASTEBIN_TITLE = "De Tünn";
      WASTEBIN_BASE_URL = "https://bin.jka.one";
      WASTEBIN_ADDRESS_PORT = "127.0.0.1:8234";
    };
  };
}
