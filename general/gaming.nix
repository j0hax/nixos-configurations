{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ sauerbraten ballerburg quake3e minecraft superTuxKart ];

  programs.steam.enable = true;
  programs.gamemode.enable = true;
}
