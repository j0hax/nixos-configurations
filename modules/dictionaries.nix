

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    hunspell
    hunspellDicts.en_US-large
    hunspellDicts.de_DE
    hyphen
  ];

  environment.pathsToLink =
    [ "/share/hunspell" "/share/myspell" "/share/hyphen" ];

  environment.variables.DICPATH =
    "/run/current-system/sw/share/hunspell:/run/current-system/sw/share/hyphen";
}

