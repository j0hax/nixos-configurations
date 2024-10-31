{
  pkgs,
  config,
  ...
}:
{
  # TODO: Use home-manager instead?
  services = {
    syncthing = {
      enable = true;
      user = "johannes";
      dataDir = "/home/johannes/Sync";
    };
  };

}
