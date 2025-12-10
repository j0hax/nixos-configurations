{
  config,
  pkgs,
  ...
}:
{
  /*
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks --cmd sway";
          user = "greeter";
        };
      };
    };
  */

  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    mako
    ghostty
    fuzzel
    mako
    brightnessctl
  ];
}
