{
  lib,
  pkgs,
  ...
}:
{
  home.username = "johannes";
  home.homeDirectory = "/home/johannes";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  imports = [
    ./packages.nix
    ./git.nix
    ./helix.nix
    ./shell.nix
    ./gnome.nix
  ];

  home.sessionVariables.MANPAGER = "${lib.getExe pkgs.bat} -plman --paging=always";

  home.shellAliases = {
    cat = "bat";
    ls = "eza";
  };

  services = {
    ssh-agent.enable = true;
    gpg-agent.enable = true;
  };
}
