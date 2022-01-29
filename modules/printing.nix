{ config, lib, pkgs, ... }: {
  services.printing.enable = lib.mkDefault true;
  services.printing.drivers = with pkgs; [ gutenprint hplip ];
}
