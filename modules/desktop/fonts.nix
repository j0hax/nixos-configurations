{
  config,
  pkgs,
  ...
}:
{
  fonts = {
    packages =
      with pkgs;
      [
        inter
        libertinus
        iosevka
        montserrat
        paratype-pt-sans
      ]
      ++ builtins.map (v: iosevka-bin.override { variant = v; }) [
        ""
        "Aile"
        "Curly"
        "CurlySlab"
        "Etoile"
      ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Libertinus" ];
        sansSerif = [ "Inter" ];
        monospace = [ "Iosevka" ];
      };
    };
  };
}
