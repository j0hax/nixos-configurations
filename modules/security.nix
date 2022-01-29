{ config, pkgs, lib, ... }: {
  security.pam.u2f = {
    enable = true;
    cue = true;
  };

  services.pcscd.enable = true;

  services.opensnitch.enable = true;

  networking.firewall = {
    enable = lib.mkDefault true;
    allowPing = lib.mkDefault false;
  };

  environment.systemPackages = with pkgs; [
    libfido2
    python3Packages.solo-python
    yubikey-manager
    chkrootkit
    lynis
  ];
}
