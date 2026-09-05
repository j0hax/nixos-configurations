{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.jka.services.minecraft;
in
{
  options.jka.services.minecraft = {
    enable = lib.mkEnableOption "Minecraft server";

    jvmOpts = lib.mkOption {
      type = lib.types.str;
      default = "-Xms4096M -Xmx6114M";
      description = "JVM options for the Minecraft server.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.minecraft-server = {
      enable = true;
      package = pkgs.unstable.minecraft-server;
      eula = true;
      openFirewall = true;
      declarative = true;
      serverProperties = {
        difficulty = "normal";
        gamemode = "survival";
        max-players = 69;
        motd = "\\u00a7f\\u2b22\\u00a78\\u2b22\\u00a72\\u2b22\\u00a7f\\u2b22\\u00a7r\\u00a7o Jetzt auch in Vegan!\\u00a7r";
        online-mode = false;
        view-distance = 16;
      };
      inherit (cfg) jvmOpts;
    };
  };
}
