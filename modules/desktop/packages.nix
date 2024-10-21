{
  config,
  pkgs,
  ...
}:
{
  # Generic GUI packages
  environment.systemPackages = with pkgs; [
    mpv
    libreoffice
    texlive.combined.scheme-full
    texmaker
  ];

  programs = {
    localsend.enable = true;
    ausweisapp.enable = true;
    thunderbird.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
