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
        # Generally nice
        inter
        libertinus
        crimson-pro
        eb-garamond
        libre-caslon
        cardo
        gentium
        junicode
        font-awesome
        vt323

        # Utilitarian
        atkinson-hyperlegible-next
        atkinson-hyperlegible-mono

        # Frisia
        montserrat
        gyre-fonts

        # Company
        paratype-pt-sans

        # Source
        source-sans
        source-serif
        source-code-pro

        # Good collections
        league-of-moveable-type
        open-fonts
        dotcolon-fonts
        inriafonts
      ]
      ++ builtins.map (v: iosevka-bin.override { variant = v; }) [
        ""
        "Aile"
        "Curly"
        "CurlySlab"
        "Etoile"
        "SGr-IosevkaTerm"
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
