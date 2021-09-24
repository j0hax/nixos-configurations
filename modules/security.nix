{ config, pkgs, ... }:
{
  security.pam.u2f = {
    enable = true;
    cue = true;
  };

  boot.initrd.luks.fido2Support = true;
}
