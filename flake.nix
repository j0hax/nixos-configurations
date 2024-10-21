{
  description = "Johannes' NixOS Configurations";

  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    agenix.url = "github:ryantm/agenix";
  };

  outputs =
    {
      self,
      nixpkgs,
      agenix,
      nixos-hardware,
      ...
    }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;

      # Bundle of common modules, including nix flakes
      commonModules = name: [
        {
          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];
          networking.hostName = name;
        }
        ./hosts/${name}
        ./modules/services
        ./modules/packages
        ./modules/system
        ./modules/user/johannes
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
