{ pkgs, config, ... }: {
  virtualisation.libvirtd.enable = true;
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  environment.systemPackages = with pkgs; [ virt-manager lazydocker ];

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
}
