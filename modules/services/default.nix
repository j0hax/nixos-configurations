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
  ];
}
