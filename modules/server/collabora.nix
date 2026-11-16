{
  lib,
  config,
  ...
}:
let
  cfg = config.jka.services.collabora;
in
{
  options.jka.services.collabora = {
    enable = lib.mkEnableOption "Collabora Online (LibreOffice Online)";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "office.jka.one";
      description = "Domain for Collabora Online.";
    };
  };

  config = lib.mkIf cfg.enable {
    jka.services.caddy.enable = lib.mkDefault true;

    services.caddy.virtualHosts.${cfg.domain}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString config.services.collabora-online.port}
    '';

    services.collabora-online = {
      enable = true;
    };
  };
}
