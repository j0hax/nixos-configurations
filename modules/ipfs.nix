{ config, lib, ... }:
{
  # IPFS is cool
  services.ipfs = {
    enable = lib.mkDefault true;
    user = "johannes";
    autoMount = lib.mkDefault true;
    startWhenNeeded = lib.mkDefault true;
    localDiscovery = lib.mkDefault true;
    enableGC = lib.mkDefault true;
  };
}
