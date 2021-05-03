{ config, pkgs, ... }:
{
  users.motd = with config; ''
    Welcome to ${networking.hostName}

    - This server is managed by NixOS
    - All changes are futile

    OS:      NixOS ${system.nixos.release} (${system.nixos.codeName})
    Version: ${system.nixos.version}
    Kernel:  ${boot.kernelPackages.kernel.version}
  '';

  # Shell Preferences
  environment.homeBinInPath = true;
}
