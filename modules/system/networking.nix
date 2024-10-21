{
  config,
  pkgs,
  ...
}:
{
  networking.networkmanager.wifi.backend = "iwd";
  services.mullvad-vpn = {
    enable = true;
    enableExcludeWrapper = true;
  };
}
