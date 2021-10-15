{
  description = "Johannes' NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager }: rec {
    # Include everything from our general folder
    nixosModules = lib.jx.modulesFrom ./modules;

    # Configuration per host
    nixosConfigurations = lib.jx.configurationsFrom ./hosts;

    lib = { jx = import ./lib { lib = nixpkgs.lib; }; };
  };
}
