{ lib, ... }:
lib.mkDefault
{
  location.provider = "geoclue2";
  services.geoclue2 = {
    enable = true;
    # if using beaconDB
    geoProviderUrl = "https://api.beacondb.net/v1/geolocate";
  };
}
