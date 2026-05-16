{
  pkgs,
  ...
}:
{
  services = {
    displayManager.plasma-login-manager = {
      enable = true;
    };
    desktopManager.plasma6.enable = true;
  };

  environment.systemPackages =
    with pkgs.kdePackages;
    [
      yakuake
      kcalc
      kclock
      ksystemlog
      kcolorchooser
      kolourpaint
    ]
    ++ (with pkgs; [
      transmission_4-qt
    ]);

  programs.kdeconnect.enable = true;
}
