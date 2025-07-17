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
  settings = {
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
  };
}
