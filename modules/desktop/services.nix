{ pkgs, config, ... }:
{
  # Pipewire
  hardware = {
    pulseaudio.enable = false;
    keyboard.qmk.enable = true;
  };

  services = {
    # Pipewire
    pipewire = {
      enable = true;
      pulse.enable = true;
      raopOpenFirewall = true;

      # AirPlay Configuration
      extraConfig.pipewire."10-airplay" = {
        context.modules = [
          {
            "name" = "libpipewire-module-raop-discover";
            "args" = { };
          }
        ];
      };
    };

    # Device I/O
    udisks2.enable = true;
    usbmuxd.enable = true;

    # Automatic timezone
    tzupdate.enable = true;

    # Enable CUPS to print documents.
    printing.enable = true;
  };
}
