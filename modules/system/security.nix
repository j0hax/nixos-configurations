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
  services.openssh = {
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
    banner = ''
      ┌──────────────────────────────────────────────────────────────────────────┐
      │ This system is for authorized users only. All activities on this system  │
      │ are monitored and logged. Unauthorized access is strictly prohibited and │
      │ will be prosecuted to the full extent of the law.                        │
      └──────────────────────────────────────────────────────────────────────────┘
    '';
  };

  services.fail2ban = {
    enable = true;
    bantime-increment.enable = true;
  };
}
