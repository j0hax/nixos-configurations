{ home-manager, ... }:
{
  # Taken from https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-nixos-module
  imports = [
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
    }
  ];
}
