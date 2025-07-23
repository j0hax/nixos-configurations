{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    zulip
    kemai
    drawio
    shell-gpt
    gopass
    teams-for-linux
    zoom-us
    pwgen
  ];

  # Add banner
  services.displayManager.gdm.banner = ''
    Johannes Arnold
    jarnold@b1-systems.de
  '';

  # Filter Mic for meetings
  programs.noisetorch.enable = true;
}
