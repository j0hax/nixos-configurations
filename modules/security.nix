{ config, pkgs, ... }: {
  security.pam.u2f = {
    enable = true;
    cue = true;
  };

  services.pcscd.enable = true;

  services.opensnitch.enable = true;

  environment.systemPackages = with pkgs; [
    libfido2
    python3Packages.solo-python
    yubikey-manager
  ];
}
