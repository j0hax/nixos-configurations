{ pkgs, config, ... }: {
  virtualisation.libvirtd.enable = true;
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  environment.systemPackages = [ pkgs.virt-manager ];
}
