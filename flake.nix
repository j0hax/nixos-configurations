{
  description = "Johannes' NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05-small";
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

      # Bundle of common modules applied to every host
      commonModules = name: [
        { networking.hostName = name; }
        ./hosts/${name}/configuration.nix
        ./modules/system
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
          ./modules/desktop
          ./modules/user/johannes
        ];

        # MacBook Pro
        clay.modules = [
          nixos-hardware.nixosModules.common-pc-laptop-ssd
          ./modules/desktop
          ./modules/user/johannes
        ];

        # Work laptop
        aptenodytes.modules = [
          nixos-hardware.nixosModules.tuxedo-infinitybook-pro14-gen9-intel
          ./modules/desktop
          ./modules/desktop/gaming.nix
          ./modules/system/virtualisation.nix
          ./modules/user/johannes
          ./modules/work
        ];

        # Mac Mini home server
        kneippweg.modules = [
          nixos-hardware.nixosModules.common-pc-laptop-ssd
          ./modules/user/johannes
          ./modules/server/minecraft.nix
        ];

        # Hetzner ARM VPS
        skylab = {
          system = "aarch64-linux";
          modules = [
            ./modules/user/johannes
            ./modules/server/auth.nix
            ./modules/server/cryptpad.nix
            ./modules/server/glance.nix
            ./modules/server/jellyfin.nix
            ./modules/server/matrix.nix
            ./modules/server/mealie.nix
            ./modules/server/wireguard.nix
            ./modules/server/xmpp.nix
            ./modules/server/cryptpad.nix
          ];
        };
      };

      # Import every .nix file in `dir` as an attrset entry keyed by its basename
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

      # Re-usable modules (auto-imported from ./modules/*.nix)
      nixosModules = modulesFrom ./modules;

      # NixOS hosts
      nixosConfigurations = lib.mapAttrs mkSystem systems;
    };
}
