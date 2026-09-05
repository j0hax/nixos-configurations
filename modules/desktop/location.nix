{
  lib,
  config,
  ...
}:
let
  cfg = config.jka.desktop;
in
{
  config = lib.mkIf cfg.enable (lib.mkDefault {
    location.provider = "geoclue2";
    services.geoclue2 = {
      enable = true;
      geoProviderUrl = "https://api.beacondb.net/v1/geolocate";
    };
  });
}
