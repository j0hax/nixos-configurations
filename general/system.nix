{ config, ... }:
{
  # Remote access is critical
  services.openssh.enable = true;

  # Add myself as a user
  users.users.johannes = {
    description = "Johannes Arnold";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
