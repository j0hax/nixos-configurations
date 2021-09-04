{ config, ... }: {
  services.borgbackup.jobs.documents = {
    paths = "/home/johannes/Documents";
    repo = "hgov5651@hgov5651.repo.borgbase.com:repo";
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat /root/backup-password";
    };
    prune.keep = {
      hourly = 24;
      daily = 31;
      weekly = 4;
      monthly = -1;
    };
    extraPruneArgs = "--save-space";
    startAt = "hourly";
    compression = "auto,lzma";
  };
}
