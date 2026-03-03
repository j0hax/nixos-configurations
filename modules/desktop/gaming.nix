{ pkgs, ... }:
{
  programs = {
    steam.enable = true;
  };

  environment.systemPackages = with pkgs; [
    mindustry-wayland
    # discord
    mumble
    # frozen-bubble
    supertux
    supertuxkart
    urbanterror
    xonotic
    sauerbraten
    beyond-all-reason
    prismlauncher
    lutris
    mangohud
  ];
}
