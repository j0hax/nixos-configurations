{ config, pkgs, lib, ... }: {
  users.motd = with config; ''
    Welcome to ${networking.hostName}!

    OS:      NixOS ${system.nixos.release} (${system.nixos.codeName})
    Version: ${system.nixos.version}
    Kernel:  ${boot.kernelPackages.kernel.version}
  '';

  # Enable developer man pages
  documentation = lib.mkDefault {
    dev.enable = true;
    man.generateCaches = true;
  };
  environment.systemPackages = [ pkgs.posix_man_pages ];

  # Environment variables
  environment.variables = { DO_NOT_TRACK = "1"; };

  # Shell Preferences
  environment.localBinInPath = lib.mkDefault true;

  # Denglisch Locale ;)
  i18n.defaultLocale = "eo.UTF-8";
  i18n.extraLocaleSettings = lib.mkDefault { LC_MONETARY = "de_DE.UTF-8"; };

  # Keyboard options
  services.xserver = lib.mkDefault {
    layout = "us";
    xkbVariant = "altgr-intl";
  };
}
