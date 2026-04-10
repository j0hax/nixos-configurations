{
  pkgs,
  sops,
  config,
  ...
}:
{
  sops.secrets.acme = {
    sopsFile = ../../secrets/acme.env;
    format = "dotenv";
  };
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "johannes@rnold.online";
      dnsProvider = "porkbun";
      environmentFile = config.sops.secrets.acme.path;
    };
  };
}
