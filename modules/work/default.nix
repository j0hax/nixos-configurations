{ pkgs, lib, ... }:
{
  # Force LTS kernel
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;

  environment.systemPackages = with pkgs; [
    zulip
    kemai
    drawio
  ];
}
