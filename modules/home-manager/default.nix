{ pkgs, lib, ... }: {
  home-manager.useGlobalPkgs = lib.mkDefault true;
  home-manager.useUserPackages = lib.mkDefault true;
  home-manager.users.johannes = import ./johannes;
}
