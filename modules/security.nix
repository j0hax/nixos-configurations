{ config, pkgs, lib, ... }: {
  security.pam.u2f = {
    enable = lib.mkDefault true;
    cue = lib.mkDefault true;
  };

  services.pcscd.enable = lib.mkDefault true;

  services.opensnitch.enable = lib.mkDefault true;

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
