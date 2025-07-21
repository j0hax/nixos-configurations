{ pkgs, lib, ... }:
{
  # Swap sudo for sudo-rs
  security = {
    sudo.enable = false;
    sudo-rs.enable = true;
  };

  # Disable root user
  users.users.root.hashedPassword = "!";

  # Disable password login for SSH
  services.openssh.settings = {
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
  };

  services.fail2ban = {
    enable = true;
    bantime-increment.enable = true;
  };
}
