{
  description = "Johannes' NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager }:
    let

      lib = nixpkgs.lib;

      # Function to create (common) desktop system configuration
      desktopConfig = { dir, system ? "x86_64-linux" }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs.nixos-hardware = self.inputs.nixos-hardware;
          modules = [
            ({ ... }: {
              imports = [
                # Include host-specific configuration files and all modules
                (import ("${dir}/configuration.nix"))
                home-manager.nixosModules.home-manager
              ] ++ (lib.attrValues self.nixosModules);
            })
          ];
        };

      # Read all modules from a specific folder
      modulesFrom = dir:
        lib.listToAttrs (map (file: {
          name = builtins.head (builtins.split "\\." file);
          value = import (dir + "/${file}");
        }) (lib.attrNames (builtins.readDir dir)));
    in {
      # Include everything from our general folder
      nixosModules = (modulesFrom ./modules);

      # Configuration per host
      nixosConfigurations =
        lib.genAttrs (lib.attrNames (builtins.readDir ./hosts))
        (hostname: desktopConfig { dir = ./hosts + "/${hostname}"; });
    };
}
