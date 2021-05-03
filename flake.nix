{
  description = "Johannes' NixOS Modules";

  outputs = { self }: {
    nixosModules = {
      environment = import ./environment.nix;
      maintenance = import ./maintenance.nix;
      packages = import ./packages.nix;
      system = import ./system.nix;
    };
  };
}
