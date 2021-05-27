{ config, pkgs, lib, ... }:
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
  environment.homeBinInPath = lib.mkDefault true;
  programs.bash.promptInit = lib.mkDefault ''eval "$(starship init bash)"'';
  programs.thefuck.enable = true;
  environment.shellAliases = { "cat" = "bat"; };
}
