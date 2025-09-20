{ pkgs, ...}:
{
  programs = {
    steam.enable = true;
  };

  environment.systemPackages = with pkgs; [
    mindustry-wayland
    discord
    mumble
    frozen-bubble
    supertux
    supertuxkart
    urban-terror
    xonotic
    sauerbraten
    beyond-all-reason
    
  ];
}
