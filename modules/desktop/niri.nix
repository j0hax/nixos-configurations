{
  pkgs,
  noctalia,
  ...
}:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --asterisks --cmd niri-session";
      };
    };
  };

  programs = {
    niri.enable = true;
    foot = {
      enable = true;
      settings = {
        main = {
          font = "Iosevka:size=16";
        };
      };
    };
    seahorse.enable = true;
  };

  # Polkit authentication
  security.soteria.enable = true;

  # Recommended services for Noctalia
  services.upower.enable = true;
  services.gnome.gnome-keyring.enable = true;
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

  # Required for Nautilus to fully function
  services.gvfs.enable = true;

  environment.systemPackages = with pkgs; [
    ddcutil
    xwayland-satellite
    posy-cursors
    noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    quickshell
    kdlfmt
    libnotify
    swww

    # Select GNOME apps
    nautilus
    papers
    loupe
    file-roller
    adwaita-icon-theme

    (writeShellScriptBin "noctalia-restart" ''
      kill $(pgrep quickshell)
      noctalia-shell > /dev/null & disown
    '')
  ];

}
