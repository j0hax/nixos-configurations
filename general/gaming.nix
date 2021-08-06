{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ sauerbraten quake3e superTuxKart ];

  programs.steam.enable = true;
  programs.gamemode.enable = true;
}
