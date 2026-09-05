{
  lib,
  config,
  ...
}:
let
  cfg = config.jka.services.jellyfin;
in
{
  options.jka.services.jellyfin = {
    enable = lib.mkEnableOption "Jellyfin media server";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "jka.one";
      description = "Base domain for Jellyfin.";
    };

    serverAliases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "flix.jka.one"
        "jellyfin.arnold.onl"
        "flix.arnold.onl"
      ];
      description = "Additional domain aliases for the Jellyfin virtual host.";
    };
  };

  config = lib.mkIf cfg.enable {
    jka.services.caddy.enable = true;

    services.caddy.virtualHosts."jellyfin.${cfg.domain}" = {
      inherit (cfg) serverAliases;
      extraConfig = ''
        encode
        reverse_proxy 127.0.0.1:8096
      '';
    };

    services.jellyfin.enable = true;
  };
}
