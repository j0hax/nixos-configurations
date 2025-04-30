{ pkgs, lib, ... }:
{
  # Force LTS kernel
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;

  environment.systemPackages = with pkgs; [
    zulip
    kemai
    drawio
    shell-gpt
    gopass
    teams-for-linux
  ];

  # Add banner
  services.xserver.displayManager.gdm.banner = ''
    Johannes Arnold
    jarnold@b1-systems.de
  '';

  # Filter Mic for meetings
  programs.noisetorch.enable = true;
}
