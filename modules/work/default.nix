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
    awscli2
    rustdesk
  ];

  # Add banner
  services.displayManager.gdm.banner = ''
    Johannes Arnold
    jarnold@b1-systems.de
  '';

  # Filter Mic for meetings
  programs.noisetorch.enable = true;
}
