{ pkgs, lib, ... }:
{
  # Force LTS kernel
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;

  environment.systemPackages = with pkgs; [
    zulip
    kemai
    drawio
    shell-gpt
  ];

  # Add banner
  services.xserver.displayManager.gdm.banner = ''
    Johannes Arnold
    jarnold@b1-systems.de
  '';
}
