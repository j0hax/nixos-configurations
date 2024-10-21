{
  config,
  pkgs,
  ...
}:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks --cmd sway";
        user = "greeter";
      };
    };
  };
}
