{ config, lib, pkgs, ... }:
{
  fonts.fonts = with pkgs; [
    anonymousPro
    corefonts
    fira
    fira-code
    fira-mono
    inconsolata
    lato
    libertine
    twitter-color-emoji
    yanone-kaffeesatz
  ];

  fonts.fontconfig.defaultFonts = lib.mkDefault {
    serif = [ "Linux Libertine" ];
    sansSerif = [ "Fira" ];
    monospace = [ "Inconsolata" ];
    emoji = [ "Twitter Color Emoji" ];
  };
}
