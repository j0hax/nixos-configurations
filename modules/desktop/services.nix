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
