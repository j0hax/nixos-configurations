{ config, pkgs, lib, ... }: {
  users.motd = with config; ''
    Welcome to ${networking.hostName}

    - This server is managed by NixOS
    - All changes are futile

    OS:      NixOS ${system.nixos.release} (${system.nixos.codeName})
    Version: ${system.nixos.version}
    Kernel:  ${boot.kernelPackages.kernel.version}
  '';

  # Enable developer man pages
  documentation.dev.enable = true;
  environment.systemPackages = [ pkgs.posix_man_pages ];

  # Shell Preferences
  environment.homeBinInPath = lib.mkDefault true;
  programs.bash.promptInit = lib.mkDefault ''eval "$(starship init bash)"'';
  programs.thefuck.enable = true;
  environment.shellAliases = { "cat" = "bat"; };

  # Denglisch Locale ;)
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = lib.mkDefault {
    LC_TIME = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
  };

  # Keyboard options
  services.xserver = lib.mkDefault {
    layout = "us";
    xkbVariant = "altgr-intl";
  };
}
