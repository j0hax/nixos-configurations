{ pkgs, lib, config, ... }: {
  security.rtkit.enable = lib.mkDefault true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = lib.mkDefault true;
    alsa.enable = lib.mkDefault true;
    alsa.support32Bit = lib.mkDefault true;
    pulse.enable = lib.mkDefault true;
  };
}
