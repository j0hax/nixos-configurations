{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./restic.nix
    ./system.nix
    ./clamav.nix
    ./syncthing.nix
  ];
}
