{ config, pkgs, lib, ... }: {

  # Use a kernel tuned to desktop workloads
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

  boot.kernelParams = [ "mitigations=off" ];

  # Enable common filesystems
  boot.supportedFilesystems = [ "ntfs" ];

  # Enable Zramswap
  zramSwap.enable = lib.mkDefault true;

  # Remote access is critical
  services.openssh.enable = lib.mkDefault true;

  # Enable Uptime monitoring
  services.tuptime = {
    enable = lib.mkDefault true;
    timer.enable = lib.mkDefault true;
  };

  # Save power, even on desktop devices
  services.auto-cpufreq.enable = lib.mkDefault true;

  # Auto-Upgrade the system
  system.autoUpgrade = lib.mkDefault {
    enable = true;
    flake = "github:j0hax/nixos-configurations";
  };

  # Use ZSH as the use shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Add myself as a user
  users.users.johannes = {
    description = "Johannes Arnold";
    isNormalUser = lib.mkDefault true;
    extraGroups = [ "wheel" "networkmanager" "dialout" "docker" "wireshark" ];
  };

  ## Networking

  # iOS Tethering
  services.usbmuxd.enable = true;

  # DNS over TLS
  networking = {
    nameservers = [ "127.0.0.1" "::1" ];
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";
  };

  services.stubby = {
    enable = lib.mkDefault true;
    settings = pkgs.stubby.passthru.settingsExample;
  };
}
