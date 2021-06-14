{ config, lib, pkgs, ... }:
{
  fonts.fonts = with pkgs; [
    corefonts
    fira
    lato
    league-of-moveable-type
    libertine
    (nerdfonts.override {
      fonts = [
        "Agave"
        "FiraCode"
        "Iosevka"
      ];
    })
    twitter-color-emoji
    yanone-kaffeesatz
  ];

  fonts.fontconfig.defaultFonts = lib.mkDefault {
    serif = [ "Linux Libertine" ];
    sansSerif = [ "Fira" ];
    monospace = [ "Fira Code" ];
    emoji = [ "Twitter Color Emoji" ];
  };
}
