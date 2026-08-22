{ pkgs, config, lib, ... }:
{
  services.minecraft-server = {
    enable = true;
    package = pkgs.unstable.minecraft-server;
    eula = true;
    openFirewall = true; # Opens the port the server is running on (by default 25565 but in this case 43000)
    declarative = true;
    serverProperties = {
      difficulty = "normal";
      gamemode = "survival";
      max-players = 69;
      motd = "\\u00a7f\\u2b22\\u00a78\\u2b22\\u00a72\\u2b22\\u00a7f\\u2b22\\u00a7r\\u00a7o Jetzt auch in Vegan!\\u00a7r";
      online-mode = false;
      view-distance = 16;
    };
    jvmOpts = "-Xms4096M -Xmx6114M";
  };
}
