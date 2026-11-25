{
  description = "Johannes' NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    mmbridge = {
      url = "github:j0hax/mmbridge";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bootvine = {
      url = "git+https://codeberg.org/wvhulle/bootvine";
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
      bootvine,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      forAllSystems = lib.genAttrs lib.systems.flakeExposed;

      # Hosts whose configuration is exercised by `nix flake check`. Every
      # host is evaluated; only those whose platform is a build platform on
      # the checking machine are also built, so `nix flake check` stays usable
      # on x86_64 without cross-compiling aarch64 (skylab) from source.
      checkedHosts =
        system: lib.attrNames (lib.filterAttrs (_: cfg: (cfg.system or system) == system) systems);

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
        bootvine.nixosModules.default
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
            jka = {
              nix.enable = true;
              desktop = {
                enable = true;
                gnome.enable = true;
              };
            };
          }
        ];

        # MacBook Pro
        clay.modules = [
          nixos-hardware.nixosModules.common-pc-laptop-ssd
          {
            jka = {
              nix.enable = true;
              desktop = {
                enable = true;
                gnome.enable = true;
              };
            };
          }
        ];

        # Work laptop
        aptenodytes.modules = [
          # nixos-hardware.nixosModules.tuxedo-infinitybook-pro14-gen9-intel
          {
            jka = {
              nix.enable = true;
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
          inputs.mmbridge.nixosModules.default
          {
            jka = {
              nix.enable = true;
              services.minecraft.enable = true;
            };
          }
        ];

        # Hetzner ARM VPS
        skylab = {
          system = "aarch64-linux";
          modules = [
            {
              jka = {
                nix.enable = true;
                services = {
                  auth.enable = true;
                  cryptpad.enable = true;
                  glance.enable = true;
                  jellyfin.enable = true;
                  matrix.enable = true;
                  # wireguard.enable = true;
                  restic-server.enable = true;
                  radio-recorder = {
                    enable = true;
                    streams.sunny = {
                      # iHeart serves HE-AAC, so copy into ADTS instead of mp3
                      format = "adts";
                      url = "https://stream.revma.ihrhls.com/zc2273";
                      path = "/var/media/Radio/sunny";
                      timezone = "America/Chicago";
                    };
                  };
                };
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

      # Checks: `nix flake check` verifies formatting and builds every host
      # that runs on the checking system. Merge conflicts, renamed options,
      # insecure or unfree packages and platform errors all fail here.
      checks = forAllSystems (
        system:
        let
          hosts = checkedHosts system;
        in
        {
          formatting =
            nixpkgs.legacyPackages.${system}.runCommand "check-formatting"
              { nativeBuildInputs = [ nixpkgs.legacyPackages.${system}.nixfmt-rfc-style ]; }
              ''
                cd ${self}
                nixfmt --check .
                touch $out
              '';
        }
        // lib.genAttrs hosts (host: self.nixosConfigurations.${host}.config.system.build.toplevel)
      );

      # Re-usable modules (auto-imported from ./modules/*)
      nixosModules = modulesFrom ./modules;

      # NixOS hosts
      nixosConfigurations = lib.mapAttrs mkSystem systems;
    };
}
