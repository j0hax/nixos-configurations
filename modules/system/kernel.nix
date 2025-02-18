{
  config,
  pkgs,
  lib,
  ...
}:
{
  boot = {
    # Use the very latest release candidate
    kernelPackages = pkgs.linuxPackages_testing;

    # Add Bcachefs support
    supportedFilesystems = [ "bcachefs" ];

    # Custom Kernel Parameters
    kernelParams = [ "mitigations=off" ];

    # Linux Kernel Modules
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback # USB Video
      perf # Performance Counting
    ];
  };
}
