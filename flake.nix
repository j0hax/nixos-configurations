{
  description = "Johannes' NixOS Configurations";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable-small;
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    home-manager.url = github:nix-community/home-manager/master;
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager }: {
    nixosConfigurations.eldridge = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixos-hardware.nixosModules.common-cpu-intel-sandy-bridge
        nixos-hardware.nixosModules.common-gpu-amd-sea-islands
        nixos-hardware.nixosModules.common-pc-ssd
        ./hardware-configuration.nix
        ./system.nix
        ./configuration.nix
        ./packages.nix
        ./environment.nix
      ];
    };

    nixosConfigurations.kirby = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixos-hardware.nixosModules.lenovo-thinkpad-x230
        nixos-hardware.nixosModules.common-pc-ssd
        ./hardware-configuration.nix
        ./configuration.nix
        ./system.nix
        ./packages.nix
        ./environment.nix
      ];
    };
  };
}
