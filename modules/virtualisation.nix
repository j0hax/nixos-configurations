{ pkgs, lib, config, ... }: {
  virtualisation.libvirtd.enable = lib.mkDefault true;

  boot = {
    kernelModules = [ "kvm-amd" "kvm-intel" ];
    kernelParams = [ "intel_iommu=on" "intel_iommu=on" ];
  };

  environment.systemPackages = with pkgs; [ virt-manager lazydocker docker-compose ];

  virtualisation.docker = {
    enable = lib.mkDefault true;
    autoPrune.enable = lib.mkDefault true;
  };
}
