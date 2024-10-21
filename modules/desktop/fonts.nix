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
