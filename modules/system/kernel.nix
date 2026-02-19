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
    initrd.systemd.enable = true;

    # Add Bcachefs support
    supportedFilesystems = {
      # bcachefs = true;
      btrfs = true;
    };

    # Custom Kernel Parameters
    kernelParams = [
      "mitigations=off"
      "kernel.task_delayacct=1"
    ];

    # Linux Kernel Modules
    extraModulePackages = with pkgs; [
      perf # Performance Counting
    ];
  };

  # Scheduler for slow block devices
  /*
    hardware.block.scheduler = {
      "mmcblk[0-9]*" = "mq-deadline";
      "sd[a-z]*" = "mq-deadline";
    };
  */

  # Enable kmscon
  # Usefor for the desktop as well as VPS
  services.kmscon = {
    # enable = true;
    hwRender = true;
    fonts = [
      {
        name = "Iosevka Term";
        package = pkgs.iosevka-bin;
      }
    ];
  };
}
