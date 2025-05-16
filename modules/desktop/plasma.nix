{
  pkgs,
  ...
}:
{
  #services.xserver.enable = true; # optional
  services = {
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
    desktopManager.plasma6.enable = true;
  };

  environment.systemPackages = with pkgs.kdePackages; [ yakuake ];
}
