{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    sauerbraten
    ballerburg
    quake3e
    minecraft
    superTuxKart
  ];

  programs.steam.enable = true;
  
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
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };

  # Important for Wine
  hardware.opengl.driSupport32Bit = true;
}
