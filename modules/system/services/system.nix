{
  lib,
  ...
}:
{
  # Generally useful services.
  services = lib.mkDefault {
    locate.enable = true;
    fwupd.enable = true;
    openssh = {
      enable = true;
      settings = {
        # Disable password authentication
        PasswordAuthentication = false;
        ChallengeResponseAuthentication = false;
      };
    };
    tuptime.enable = true;
    smartd.enable = true;
  };
}
