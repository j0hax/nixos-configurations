{
  lib,
  config,
  ...
}:
let
  cfg = config.jka.services.listmonk;
in
{
  options.jka.services.listmonk = {
    enable = lib.mkEnableOption "Listmonk mailing list manager";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "lists.test.avfrisia.de";
      description = "Domain for Listmonk.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 9000;
      description = "Internal port for Listmonk.";
    };
  };

  config = lib.mkIf cfg.enable {
    jka.services.caddy.enable = lib.mkDefault true;

    services.caddy.virtualHosts.${cfg.domain}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';

    # TODO: Re-enable when listmonk packaging is fixed
    # services.listmonk.enable = true;
  };
}
