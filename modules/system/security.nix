{ pkgs, lib, ... }:
{
  # Swap sudo for sudo-rs
  security = {
    sudo.enable = false;
    sudo-rs.enable = true;
  };
}
