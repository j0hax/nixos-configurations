{
  pkgs,
  config,
  ...
}:
{
  services.clamav = {
    daemon.enable = true;
    scanner.enable = true;
    updater.enable = true;
    fangfrisch.enable = true;
  };
}
