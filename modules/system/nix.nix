{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.jka.nix;
  isDesktop = config.jka.desktop.enable or false;
  isServer = config.jka.services or {} != {};
in
{
  options.jka.nix = {
    enable = lib.mkEnableOption "Nix daemon and settings";
    trustedUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "johannes" ];
      description = "Users trusted to use Nix commands";
    };
    maxJobs = lib.mkOption {
      type = lib.types.int;
      default = 4;
      description = "Maximum number of parallel Nix builds";
    };
    cores = lib.mkOption {
      type = lib.types.int;
      default = 0; # 0 means auto-detect
      description = "Number of CPU cores for Nix to use";
    };
    flakePath = lib.mkOption {
      type = lib.types.str;
      default = "/etc/nixos";
      description = "Path to the flake used by nh and auto-upgrade";
    };
  };

  config = lib.mkIf cfg.enable {
    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = cfg.trustedUsers;
        cores = cfg.cores;
        max-jobs = cfg.maxJobs;
      };

      # Desktop-specific: limit resource usage and prioritize interactive work
      daemonIOSchedClass = lib.mkIf isDesktop "idle";
      daemonCPUSchedPolicy = lib.mkIf isDesktop "idle";
    };

    # Essential tool for helping
    programs.nh = {
      enable = true;
      flake = cfg.flakePath;
      clean = {
        enable = true;
        dates = "daily";
      };
    };
  };
}
