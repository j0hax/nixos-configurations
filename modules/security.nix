{ config, pkgs, ... }:
{
  security.pam.u2f = {
    enable = true;
    cue = true;
  };

  environment.systemPackages = with pkgs; [ libfido2 python3Packages.solo-python ];
}
