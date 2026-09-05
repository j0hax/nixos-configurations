{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.jka.virtualisation;
in
{
  options.jka.virtualisation = {
    enable = lib.mkEnableOption "QEMU/KVM virtualisation with libvirt";
  };

  config = lib.mkIf cfg.enable {
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

    environment.systemPackages = with pkgs; [ guestfs-tools ];

    # Allow network traffic from VMs
    networking.firewall.trustedInterfaces = config.virtualisation.libvirtd.allowedBridges;
  };
}
