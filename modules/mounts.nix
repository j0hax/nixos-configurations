{ config, ... }: {
  services.davfs2.enable = true;

  fileSystems ={
    "/mnt/seafile" = {
      device = "https://seafile.cloud.uni-hannover.de/dav";
      fsType = "davfs2";
    };
  };
}
