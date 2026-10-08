{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.jka.services.redis;
in
{
  options.jka.services.redis = {
    enable = lib.mkEnableOption "Enable Redis (Valkey) Server";
  };

  config = lib.mkIf cfg.enable {
    services.redis = {
      enable = true;
      package = lib.mkDefault pkgs.valkey;
    };
  };
}
