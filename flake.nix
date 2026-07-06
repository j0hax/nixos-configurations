{
  description = "Johannes' NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      sops-nix,
      ...
    }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;

      # Bundle of common modules, including nix flakes
      commonModules = name: [
        { networking.hostName = name; } # Set the hostname.
        ./hosts/${name}/configuration.nix # Host-Specific configuration from /etc/nixos
        ./modules/system # Common system settings and packages
        ./modules/user # User configuration
        sops-nix.nixosModules.sops
        {
          sops.defaultSopsFile = ./secrets/secrets.yaml;
          sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        }
      ];

      # Define a system with common and extra modules
      mkSystem =
        name: cfg:
        nixpkgs.lib.nixosSystem rec {
          system = cfg.system or "x86_64-linux";
          modules = (commonModules name) ++ (cfg.modules or [ ]);
          specialArgs = inputs;
        };

      systems = {

        # ThinkPad
        kirby = {
          modules = [
            nixos-hardware.nixosModules.lenovo-thinkpad-x230
            nixos-hardware.nixosModules.common-pc-laptop-ssd
            ./modules/desktop
            ./modules/user/johannes
          ];
        };

        # MacBook Pro
        clay = {
          modules = [
            nixos-hardware.nixosModules.common-pc-laptop-ssd
            ./modules/desktop
            ./modules/user/johannes
          ];
        };

        # Work Laptop
        aptenodytes = {
          modules = [
            nixos-hardware.nixosModules.tuxedo-infinitybook-pro14-gen9-intel
            ./modules/desktop
            ./modules/user/johannes
            ./modules/work
            ./modules/system/virtualisation.nix
            ./modules/desktop/gaming.nix
          ];
        };

        # Mac Mini Server
        kneippweg = {
          modules = [
            nixos-hardware.nixosModules.common-pc-laptop-ssd
            ./modules/user/johannes
            ./modules/server/minecraft.nix
          ];
        };

        # Hetzner VPS
        skylab = {
          system = "aarch64-linux";
          modules = [
            ./modules/user/johannes
            ./modules/server/auth.nix
            ./modules/server/jellyfin.nix
            ./modules/server/glance.nix
            ./modules/server/matrix.nix
            ./modules/server/wireguard.nix
            ./modules/server/xmpp.nix
            ./modules/server/cryptpad.nix
          ];
        };

      };

      # Read all modules from a specific folder
      modulesFrom =
        dir:
        nixpkgs.lib.listToAttrs (
          map (file: {
            name = builtins.head (builtins.split "\\." file);
            value = import (dir + "/${file}");
          }) (nixpkgs.lib.attrNames (builtins.readDir dir))
        );
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      # Expose all modules for re-use
      nixosModules = (modulesFrom ./modules);

      # Expose all NixOS configurations for the defined hosts
      nixosConfigurations = nixpkgs.lib.mapAttrs mkSystem systems;
    };
}
