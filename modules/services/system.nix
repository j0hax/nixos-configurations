{
  pkgs,
  config,
  ...
}:
{
  # Generally useful services.
  services.locate.enable = true;
  services.fwupd.enable = true;
  services.openssh.enable = true;
}
