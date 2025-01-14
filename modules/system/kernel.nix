{
  config,
  pkgs,
  ...
}:
{
  # Add Bcachefs support
  boot.supportedFilesystems = [ "bcachefs" ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
    
  # Custom Kernel Parameters
  boot.kernelParams = [ "mitigations=off" ];

  # Linux Kernel Modules
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback # USB Video
    perf # Performance Counting
  ];

}
