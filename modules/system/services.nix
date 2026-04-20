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

    journalwatch = {
      enable = true;
      mailTo = "johannes@rnold.online";
      priority = 2;
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
