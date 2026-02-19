{
  description = "Johannes' NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
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
        ./modules/services # Common system services
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
            ./modules/system/virtualisation.nix
            ./modules/desktop/gaming.nix
          ];
        };
        skylab = {
          system = "aarch64-linux";
          modules = [
            ./modules/user/johannes
            ./modules/server/jellyfin.nix
            ./modules/server/glance.nix
            # ./modules/server/bin.nix
            # ./modules/server/navidrome.nix
            ./modules/server/matrix.nix
            ./modules/server/wireguard.nix
            ./modules/server/ntfy.nix
            # ./modules/server/uptime.nix
            # ./modules/server/minecraft.nix
            ./modules/server/xmpp.nix
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
