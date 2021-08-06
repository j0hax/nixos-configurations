{
  description = "Johannes' NixOS Configurations";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    #home-manager.url = github:nix-community/home-manager/master;
  };

  outputs = { self, nixpkgs, nixos-hardware }: {

    nixosModules = {
      environment = import ./general/environment.nix;
      maintenance = import ./general/maintenance.nix;
      desktop-packages = import ./general/packages.nix;
      system = import ./general/system.nix;
      backups = import ./general/backups.nix;
      fonts = import ./general/fonts.nix;
      printing = import ./general/printing.nix;
      tailscale = import ./general/tailscale.nix;
      clamav = import ./general/clamav.nix;
      virtualisation = import ./general/virtualisation.nix;
      gaming = import ./general/gaming.nix;
    };

    nixosConfigurations.eldridge = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = with self.outputs.nixosModules; [
        nixos-hardware.nixosModules.common-cpu-intel-sandy-bridge
        nixos-hardware.nixosModules.common-gpu-amd-sea-islands
        nixos-hardware.nixosModules.common-pc-ssd
        ./host-specific/eldridge/hardware-configuration.nix
        ./host-specific/eldridge/configuration.nix
        system
        environment
        maintenance
        desktop-packages
        backups
        fonts
        tailscale
      ];
    };

    nixosConfigurations.kirby = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = with self.outputs.nixosModules; [
        nixos-hardware.nixosModules.lenovo-thinkpad-x230
        nixos-hardware.nixosModules.common-pc-ssd
        ./host-specific/kirby/hardware-configuration.nix
        ./host-specific/kirby/configuration.nix
        system
        environment
        maintenance
        desktop-packages
        backups
        fonts
        printing
        tailscale
        gaming
        virtualisation
      ];
    };
  };
}
