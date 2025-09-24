{ pkgs, lib, ... }:
{
  # Swap sudo for run0
  security = {
    sudo.enable = false;
    #sudo-rs.enable = true;
    polkit.enable = true;
  };

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "sudo" ''
      echo '[Warning] sudo has been replaced with run0.'
      ${pkgs.systemd}/bin/run0 $@
    '')
  ];

  # Disable root user
  users.users.root.hashedPassword = "!";

  # Disable password login for SSH
  services.openssh = {
    startWhenNeeded = true;
    ports = [ 484 ]; # Because 22^2, get it?
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

  services.endlessh-go = {
    enable = true;
    openFirewall = true;
    port = 22;
  };

  services.fail2ban = {
    enable = true;
    bantime-increment.enable = true;
  };
}
