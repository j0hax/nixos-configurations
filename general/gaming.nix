{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ sauerbraten ];

  programs.steam.enable = true;
  programs.gamemode.enable = true;
}
