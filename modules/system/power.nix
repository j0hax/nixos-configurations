{ lib, ... }:
{
  # Replace ppd and tlp with tuned
  services.power-profiles-daemon.enable = lib.mkDefault false;
  services.tlp.enable = lib.mkForce false;
  services.tuned = lib.mkDefault {
    enable = true;
    ppdSupport = true;
    settings = {
      dynamic_tuning = true;
    };
  };
}
