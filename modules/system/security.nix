{ pkgs, lib, ... }:
{
  # Disable root user
  users.users.root.hashedPassword = "!";
  
  # Swap sudo for sudo-rs
  security = {
    sudo.enable = false;
    sudo-rs.enable = true;
  };
}
