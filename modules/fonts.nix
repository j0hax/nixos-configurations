{ config, lib, pkgs, ... }: {
  fonts.fonts = with pkgs; [
    corefonts
    fira
    inter
    lato
    league-of-moveable-type
    libertine
    (nerdfonts.override { fonts = [ "Agave" "FiraCode" "Iosevka" ]; })
    twitter-color-emoji
    yanone-kaffeesatz
    inriafonts
  ];

  fonts.fontconfig.defaultFonts = lib.mkDefault {
    serif = [ "Linux Libertine" ];
    sansSerif = [ "Inter" ];
    monospace = [ "Iosevka Term" ];
    emoji = [ "Twitter Color Emoji" ];
  };
}
