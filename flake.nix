{
  description = "Johannes' NixOS Configurations";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    #home-manager.url = github:nix-community/home-manager/master;
  };

  outputs = { self, nixpkgs, nixos-hardware }: {
    nixosConfigurations.eldridge = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixos-hardware.nixosModules.common-cpu-intel-sandy-bridge
        nixos-hardware.nixosModules.common-gpu-amd-sea-islands
        nixos-hardware.nixosModules.common-pc-ssd
        ./host-specific/eldridge/hardware-configuration.nix
        ./host-specific/eldridge/configuration.nix
        ./general/environment.nix
        ./general/maintenance.nix
        ./general/packages.nix
        ./general/system.nix
      ];
    };

    nixosConfigurations.kirby = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixos-hardware.nixosModules.lenovo-thinkpad-x230
        nixos-hardware.nixosModules.common-pc-ssd
        ./host-specific/eldridge/hardware-configuration.nix
        ./host-specific/eldridge/configuration.nix
        ./general/environment.nix
        ./general/maintenance.nix
        ./general/packages.nix
        ./general/system.nix
      ];
    };
  };
}
