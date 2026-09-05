{
  description = "Johannes' NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05-small";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-hardware,
      sops-nix,
      home-manager,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      forAllSystems = lib.genAttrs lib.systems.flakeExposed;

      # Bundle of common modules applied to every host.
      # All option-based modules are always imported so their options are
      # available everywhere; hosts enable only what they need.
      commonModules = name: [
        { networking.hostName = name; }
        {
          nixpkgs.overlays = [
            (final: prev: {
              unstable = import inputs.nixpkgs-unstable {
                inherit (final.stdenv.hostPlatform) system;
                inherit (final) config;
              };
            })
          ];
        }
        ./hosts/${name}/configuration.nix
        ./modules/system
        ./modules/desktop
        ./modules/server
        ./modules/work
        ./modules/user/johannes
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        {
          sops.defaultSopsFile = ./secrets/secrets.yaml;
          sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];

      # Build a NixOS system with common + host-specific modules
      mkSystem =
        name: cfg:
        lib.nixosSystem {
          system = cfg.system or "x86_64-linux";
          modules = (commonModules name) ++ (cfg.modules or [ ]);
          specialArgs = { inherit inputs self; };
        };

      systems = {
        # ThinkPad X230
        kirby.modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-x230
          nixos-hardware.nixosModules.common-pc-laptop-ssd
          {
            jka.desktop = {
              enable = true;
              gnome.enable = true;
            };
          }
        ];

        # MacBook Pro
        clay.modules = [
          nixos-hardware.nixosModules.common-pc-laptop-ssd
          {
            jka.desktop = {
              enable = true;
              gnome.enable = true;
            };
          }
        ];

        # Work laptop
        aptenodytes.modules = [
          nixos-hardware.nixosModules.tuxedo-infinitybook-pro14-gen9-intel
          {
            jka = {
              desktop = {
                enable = true;
                gnome.enable = true;
                gaming.enable = true;
              };
              virtualisation.enable = true;
              work.enable = true;
            };
          }
        ];

        # Mac Mini home server
        kneippweg.modules = [
          nixos-hardware.nixosModules.common-pc-laptop-ssd
          { jka.services.minecraft.enable = true; }
        ];

        # Hetzner ARM VPS
        skylab = {
          system = "aarch64-linux";
          modules = [
            {
              jka.services = {
                auth.enable = true;
                cryptpad.enable = true;
                glance.enable = true;
                jellyfin.enable = true;
                matrix.enable = true;
                wireguard.enable = true;
                xmpp.enable = true;
              };
            }
          ];
        };
      };

      # Import every directory with a default.nix as a module
      modulesFrom =
        dir:
        let
          entries = builtins.readDir dir;
          isModuleDir = name: type: type == "directory" && builtins.pathExists (dir + "/${name}/default.nix");
        in
        lib.mapAttrs (name: _: import (dir + "/${name}")) (lib.filterAttrs isModuleDir entries);
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      # Handy dev shell with the tools you actually use to manage this repo
      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          packages = with nixpkgs.legacyPackages.${system}; [
            nixfmt-rfc-style
            nil # Nix LSP
            sops
            age
            ssh-to-age
          ];
        };
      });

      # Checks: `nix flake check` will build every host + verify formatting
      checks = forAllSystems (system: {
        formatting =
          nixpkgs.legacyPackages.${system}.runCommand "check-formatting"
            { nativeBuildInputs = [ nixpkgs.legacyPackages.${system}.nixfmt-rfc-style ]; }
            ''
              cd ${self}
              nixfmt --check .
              touch $out
            '';
      });

      # Re-usable modules (auto-imported from ./modules/*)
      nixosModules = modulesFrom ./modules;

      # NixOS hosts
      nixosConfigurations = lib.mapAttrs mkSystem systems;
    };
}
