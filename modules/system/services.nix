{
  lib,
  ...
}:
{

  # Generally useful system services
  services = lib.mkDefault {
    fstrim.enable = true;
    locate.enable = true;
    fwupd.enable = true;
    tuptime.enable = true;
    smartd.enable = true;

    timesyncd.servers = [ "ntp-01.jeffgeerling.com" ];

    journalwatch = {
      enable = true;
      mailTo = "johannes@arnold.onl";
      priority = 1;
    };

    openssh = {
      enable = true;
      settings = {
        # Disable password authentication
        PasswordAuthentication = false;
        ChallengeResponseAuthentication = false;
      };
    };
  };
}
