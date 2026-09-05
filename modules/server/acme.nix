{
  lib,
  config,
  ...
}:
let
  cfg = config.jka.services.acme;
in
{
  options.jka.services.acme = {
    enable = lib.mkEnableOption "ACME certificate management via Porkbun DNS";

    email = lib.mkOption {
      type = lib.types.str;
      default = "johannes@rnold.online";
      description = "Email address for ACME registration.";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets.acme = {
      sopsFile = ../../secrets/acme.env;
      format = "dotenv";
    };

    security.acme = {
      acceptTerms = true;
      defaults = {
        inherit (cfg) email;
        dnsProvider = "porkbun";
        environmentFile = config.sops.secrets.acme.path;
      };
    };
  };
}
