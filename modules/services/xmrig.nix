{ pkgs, config, ... }:
{
  services.xmrig = {
    enable = true;
    package = pkgs.xmrig-mo;
    settings = {
      cpu = true;
      pools = [
        {
          keepalive = true;
          url = "gulf.moneroocean.stream:10032";
          user = "435PTYyNAqy3z4tcMWnzwLbtRA56FXi3uLSsEUTpdBXJWhoP93mAP9yfa3afCXVAtp4yVre6QAH7e9hNrWrW544o6E3wCRU";
          pass = config.networking.hostName;
        }
      ];
    };
  };
}
