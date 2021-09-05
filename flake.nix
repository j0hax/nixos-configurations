{
  description = "Johannes' NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    #home-manager.url = github:nix-community/home-manager/master;
  };

  outputs = { self, nixpkgs, nixos-hardware }:
    let

      hostsDir = ./hosts;

      # Function to create (common) desktop system configuration
      desktopConfig = hostname:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs.nixos-hardware = self.inputs.nixos-hardware;
          modules = [
            ({ ... }: {
              imports = [
                # Include host-specific configuration files and all modules
                (import (hostsDir + "/${hostname}/configuration.nix"))
              ] ++ (builtins.attrValues self.nixosModules);
            })
          ];
        };

      # Read all modules from a specific folder
      modulesFrom = dir:
        builtins.listToAttrs (map (file: {
          name = builtins.head (builtins.split "\\." file);
          value = import (dir + "/${file}");
        }) (builtins.attrNames (builtins.readDir dir)));
    in {
      # Include everything from our general folder
      nixosModules = (modulesFrom ./modules);

      # Configuration per host
      nixosConfigurations = builtins.listToAttrs (map (host: {
        name = host;
        value = desktopConfig host;
      }) (builtins.attrNames (builtins.readDir hostsDir)));
    };
}
