{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    sauerbraten
    ballerburg
    quake3e
    minecraft
    mangohud
    superTuxKart
  ];

  programs.steam.enable = true;

  # Configure MangoHud for all Vulkan games
  environment.variables = {
    MANGOHUD = "1";
    MANGOHUD_CONFIG = "cpu_temp,gpu_temp";
  };
  
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 20;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started' -i applications-games";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended' -i applications-games";
      };
    };
  };

  # Important for Wine
  hardware.opengl.driSupport32Bit = true;
}
