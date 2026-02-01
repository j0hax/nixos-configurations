{ pkgs, config, ... }:
{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        vhostUserPackages = with pkgs; [ virtiofsd ];
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  programs.virt-manager.enable = true;

  # Allow network traffic from VMs
  networking.firewall.trustedInterfaces = config.virtualisation.libvirtd.allowedBridges;
  # boot.kernel.sysctl."net.ipv4.ip_forwarding" = true;
  networking.nat = {
    enable = true;
    internalInterfaces = [ "virbr0" ];
  };
}
