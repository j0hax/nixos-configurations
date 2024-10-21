{ pkgs, config, ... }:
{

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Pipewire
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.udisks2.enable = true;
  services.usbmuxd.enable = true;
  hardware.keyboard.qmk.enable = true;
}
