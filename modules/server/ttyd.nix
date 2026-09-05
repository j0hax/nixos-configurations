{
  lib,
  config,
  ...
}:
let
  cfg = config.jka.services.ttyd;
in
{
  options.jka.services.ttyd = {
    enable = lib.mkEnableOption "ttyd web terminal";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "tty.jka.one";
      description = "Domain for the web terminal.";
    };
  };

  config = lib.mkIf cfg.enable {
    jka.services.caddy.enable = true;

    services.caddy.virtualHosts.${cfg.domain}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString config.services.ttyd.port}
      encode zstd gzip
      header X-Robots-Tag "noindex, nofollow"
    '';

    services.ttyd = {
      enable = true;
      writeable = true;
    };
  };
}
