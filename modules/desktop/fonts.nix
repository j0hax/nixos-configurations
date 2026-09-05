{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.jka.desktop;
in
{
  config = lib.mkIf cfg.enable {
    fonts = {
      packages =
        with pkgs;
        [
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
          cantarell-fonts

          atkinson-hyperlegible-next
          atkinson-hyperlegible-mono

          montserrat
          gyre-fonts

          paratype-pt-sans

          source-sans
          source-serif
          source-code-pro

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
  };
}
