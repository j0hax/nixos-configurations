{
  description = "Johannes' NixOS Configurations";

  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    agenix.url = "github:ryantm/agenix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      agenix,
      nixos-hardware,
      home-manager,
      ...
    }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;

      # Bundle of common modules, including nix flakes
      commonModules = name: [
        { networking.hostName = name; } # Set the hostname.
        ./hosts/${name}/configuration.nix # Host-Specific configuration from /etc/nixos
        ./modules/services # Common system services
        ./modules/packages # Common packages
        ./modules/system # Common system settings
        ./modules/user # User configuration
      ];

      agenixModules = system: [
        agenix.nixosModules.default
        {
          environment.systemPackages = [ agenix.packages.${system}.default ];
        }
      ];

      # Define a system with common and extra modules
      mkSystem =
        name: cfg:
        nixpkgs.lib.nixosSystem rec {
          system = cfg.system or "x86_64-linux";
          modules = (commonModules name) ++ (agenixModules system) ++ (cfg.modules or [ ]);
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

        clay = {
          modules = [
            nixos-hardware.nixosModules.common-pc-laptop-ssd
            ./modules/desktop
            ./modules/user/johannes
          ];
        };

        aptenodytes = {
          modules = [
            nixos-hardware.nixosModules.tuxedo-infinitybook-pro14-gen9-intel
            ./modules/desktop
            ./modules/user/johannes
            ./modules/work
          ];
        };
        skylab = {
          system = "aarch64-linux";
          modules = [
            ./modules/user/johannes
            ./modules/server/jellyfin.nix
            ./modules/server/glance.nix
            ./modules/server/bin.nix
            ./modules/server/navidrome.nix
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

      # Include everything from our general folder
      nixosModules = (modulesFrom ./modules);
      nixosConfigurations = nixpkgs.lib.mapAttrs mkSystem systems;
    };
}
