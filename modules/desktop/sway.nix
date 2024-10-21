{
  config,
  pkgs,
  ...
}:
{
  services.gnome.gnome-keyring.enable = true;
  programs.light.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  environment.systemPackages = with pkgs; [
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    mako # notification system developed by swaywm maintainer
    gammastep
  ];
}
