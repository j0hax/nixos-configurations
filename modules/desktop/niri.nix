{
  pkgs,
  lib,
  inputs,
  noctalia,
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

  programs = {
    niri.enable = true;
  };

  # Handle power and lid switch
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
  };

  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  
  services.upower = {
    enable = true;
    # ignoreLid = true;
  };

  environment.systemPackages = with pkgs; [
    ghostty
    ddcutil
    xwayland-satellite
    posy-cursors
    noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    quickshell
    kdlfmt
    libnotify
  ];

}
