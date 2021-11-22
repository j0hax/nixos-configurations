{ config, ... }:
{
  # IPFS is cool
  services.ipfs = {
    enable = true;
    user = "johannes";
    autoMount = true;
    startWhenNeeded = true;
    localDiscovery = true;
    enableGC = true;
  };
}
