{
  pkgs,
  noctalia,
  lib,
  ...
}:
{
  /*
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks --cmd niri";
          user = "greeter";
        };
      };
    };
  */

  programs.niri.enable = true;

  # Handle power and lid switch
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
  };

  services.upower = {
    enable = true;
    ignoreLid = true;
  };

  environment.systemPackages = with pkgs; [
    ghostty
    fuzzel
    xwayland-satellite
    posy-cursors
    noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    quickshell
    (python3.withPackages (pyPkgs: with pyPkgs; [ pygobject3 ]))
  ];

  services.gnome.evolution-data-server.enable = true;

  # https://docs.noctalia.dev/getting-started/nixos/#calendar-events-support

  environment.sessionVariables = {
    GI_TYPELIB_PATH = lib.makeSearchPath "lib/girepository-1.0" (
      with pkgs;
      [
        evolution-data-server
        libical
        glib.out
        libsoup_3
        json-glib
        gobject-introspection
      ]
    );
  };
}
