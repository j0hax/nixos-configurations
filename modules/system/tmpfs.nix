{
  config,
  pkgs,
  lib,
  ...
}:
{
  boot.tmp.cleanOnBoot = true;
  boot.tmp.useTmpfs = true;
}
