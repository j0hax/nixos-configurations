{
  config,
  sops,
  ...
}:
{
  sops.secrets.nullmailer = {
    sopsFile = ../../secrets/nullmailer-remotes.txt;
    format = "binary";
    owner = "nullmailer";
  };

  services.nullmailer = {
    enable = true;
    remotesFile = config.sops.secrets.nullmailer.path;
    config = {
      me = config.networking.hostName;
      defaultdomain = "jka.one";
    };
  };
}
