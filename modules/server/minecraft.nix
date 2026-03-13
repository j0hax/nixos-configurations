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
      difficulty = "normal";
      gamemode = "survival";
      max-players = 69;
      motd = "\\u00A7fIrg\\u00A78en\\u00A7adw\\u00A7fas \\u00A7rmit \\u00A79B\\u00A7e1\\u00A7rnguinen";
    };
    jvmOpts = "-Xms4096M -Xmx6114M";
  };
}
