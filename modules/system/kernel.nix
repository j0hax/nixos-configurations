{
  config,
  pkgs,
  lib,
  ...
}:
let
  # Definitely required: Tux Logo
  bootlogo = {
    name = "logo-config";
    patch = null;
    extraConfig = ''
      LOGO y
      FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER n
    '';
  };
in
{
  boot = {
    # Use the very latest release candidate
    # Note: lib.mkDefault = lib.mkOverride 1000
    kernelPackages = lib.mkOverride 1001 pkgs.linuxPackages_testing;

    kernelPatches = [ bootlogo ];

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
