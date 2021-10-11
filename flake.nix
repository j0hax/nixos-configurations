{
  description = "Johannes' NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixos-hardware }:
    let

      lib = nixpkgs.lib;

      hostsDir = ./hosts;

      # Function to create (common) desktop system configuration
      desktopConfig = { hostname, system ? "x86_64-linux" }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs.nixos-hardware = self.inputs.nixos-hardware;
          modules = [
            ({ ... }: {
              imports = [
                # Include host-specific configuration files and all modules
                (import (hostsDir + "/${hostname}/configuration.nix"))
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
      nixosConfigurations = lib.genAttrs (lib.attrNames (builtins.readDir hostsDir)) (hostname: desktopConfig { inherit hostname; });
    };
}
