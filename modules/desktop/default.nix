{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.jka.desktop;
in
{
  imports = [
    ./gnome.nix
    ./sway.nix
    ./cosmic.nix
    ./plasma.nix
    ./gaming.nix

    ./location.nix
    ./services.nix
    ./packages.nix
    ./fonts.nix
  ];

  options.jka.desktop = {
    enable = lib.mkEnableOption "desktop environment and GUI applications";

    # Options are declared unconditionally, so every default must follow
    # jka.desktop.enable: servers import this module too and must not get
    # desktop applications.
    packages = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        defaultText = lib.literalExpression "config.jka.desktop.enable";
        description = "Install desktop applications as user packages (home-manager).";
      };
      gnome = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable && cfg.gnome.enable;
        defaultText = lib.literalExpression "config.jka.desktop.enable && config.jka.desktop.gnome.enable";
        description = "Install GNOME applications.";
      };
      plasma = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable && cfg.plasma.enable;
        defaultText = lib.literalExpression "config.jka.desktop.enable && config.jka.desktop.plasma.enable";
        description = "Install Plasma applications.";
      };
      sway = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable && cfg.sway.enable;
        defaultText = lib.literalExpression "config.jka.desktop.enable && config.jka.desktop.sway.enable";
        description = "Install Sway utilities.";
      };
      gaming = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable && cfg.gaming.enable;
        defaultText = lib.literalExpression "config.jka.desktop.enable && config.jka.desktop.gaming.enable";
        description = "Install games.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      # Use a tweaked Kernel by default, the host may override this
      kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

      # Use a pretty boot screen
      loader = {
        timeout = 0;
        systemd-boot = {
          consoleMode = "max";
          memtest86.enable = true;
          netbootxyz.enable = true;
        };
      };

      kernelParams = [
        "quiet"
        "splash"
      ];
    };

    # Use NetworkManager for desktop configurations
    networking.networkmanager = lib.mkDefault {
      enable = true;
      wifi = {
        macAddress = "stable-ssid";
      };
      ethernet.macAddress = "stable";
      dns = "systemd-resolved";
      plugins = with pkgs; [
        networkmanager-openvpn
        networkmanager-openconnect
        networkmanager-ssh
        networkmanager-l2tp
        networkmanager-libreswan
      ];
    };

    # Nix settings are managed by modules/system/nix.nix

    security.rtkit.enable = true;

    # Required for controlling monitors
    hardware.i2c.enable = true;
  };
}
