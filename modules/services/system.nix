{
  lib,
  ...
}:
{
  # Generally useful services.
  services = lib.mkDefault {
    locate.enable = true;
    fwupd.enable = true;
    openssh.enable = true;
    tuptime.enable = true;
    smartd.enable = true;
  };
}
