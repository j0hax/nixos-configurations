{ config, pkgs, ... }:
{
  security.pam.u2f.enable = true;
  boot.initrd.luks.fido2Support = true;
}
