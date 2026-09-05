{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.jka.users.johannes;
in
{
  options.jka.users.johannes = {
    enable = lib.mkEnableOption "user account for Johannes" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.johannes = {
      description = "Johannes Karl Arnold";
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = [
        "wheel"
        "video"
        "libvirtd"
        "dialout"
        "adbusers"
        "pcap"
        "lp"
        "ydotool"
      ];
    };

    nix.settings.trusted-users = [ "johannes" ];

    home-manager.users.johannes = import ./home.nix;
  };
}
