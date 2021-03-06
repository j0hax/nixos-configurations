{ pkgs, lib, config, ... }: {
  virtualisation.libvirtd.enable = lib.mkDefault true;

  # Allow SSHing into virtual machines
  system.nssDatabases.hosts = [ "libvirt" "libvirt_guest" ];

  boot = {
    kernelModules = [ "kvm-amd" "kvm-intel" ];
    kernelParams = [ "intel_iommu=on" "intel_iommu=on" ];
  };

  environment.systemPackages = with pkgs; [
    virt-manager
    lazydocker
    docker-compose
  ];

  virtualisation.docker = {
    enable = lib.mkDefault true;
    autoPrune.enable = lib.mkDefault true;
  };
}
