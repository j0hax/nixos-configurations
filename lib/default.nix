{ lib }: rec {

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

  # Generate NixOS Configurations from a given directory
  configurationsFrom = dir: lib.genAttrs (lib.attrNames (builtins.readDir dir))
        (hostname: lib.desktopConfig { inherit hostname; });
}
