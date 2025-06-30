{ ... }:
{
  hardware.keyboard.qmk.enable = true;

  services = {
    # Audio
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      #pulse.enable = true;
      audio.enable = true;
      raopOpenFirewall = true;

      extraConfig.pipewire = {
        # AirPlay and Zeroconf Configuration
        "10-zeroconf" = {
          context.modules = [
            {
              "name" = "libpipewire-module-raop-discover";
              "args" = { };
            }
            {
              "name" = "module-zeroconf-discover";
              "args" = { };
            }
            {
              "name" = "module-zeroconf-publish";
              "args" = { };
            }
          ];
        };
      };
    };

    # Device I/O
    udisks2.enable = true;
    usbmuxd.enable = true;

    # Automatic timezone
    #tzupdate.enable = true;
    automatic-timezoned.enable = true;

    # Enable CUPS to print documents.
    printing.enable = true;
  };
}
