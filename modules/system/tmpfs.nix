{
  config,
  pkgs,
  lib,
  ...
}:
{
  boot.tmp.cleanOnBoot = true;
  boot.tmp.useTmpfs = true;
  systemd.services.nix-daemon = {
    environment.TMPDIR = "/var/tmp";
    serviceConfig.LimitNOFILE = lib.mkForce "infinity";
  };
}
