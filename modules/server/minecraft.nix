{ pkgs, ... }:
{
  services.minecraft-server = {
    enable = true;
    package = pkgs.papermc;
    eula = true;
    openFirewall = true; # Opens the port the server is running on (by default 25565 but in this case 43000)
    declarative = true;
    whitelist = {
      # This is a mapping from Minecraft usernames to UUIDs. You can use https://mcuuid.net/ to get a Minecraft UUID for a username
      j0hax = "9c4e91c2-43f5-4e0b-bd04-77962492e817";
    };
    serverProperties = {
      difficulty = 2;
      gamemode = "survival";
      max-players = 69;
      motd = "\u00a7eIrgendwas\u00a7f mit\u00a79 Pinguinen";
      white-list = true;
    };
    jvmOpts = "-Xms2048M -Xmx4096M";
  };
}
