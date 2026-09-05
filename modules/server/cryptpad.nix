{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.jka.services.cryptpad;

  ssoPlugin = pkgs.fetchFromGitHub {
    owner = "cryptpad";
    repo = "sso";
    rev = "0.4.0";
    hash = "sha256-WkiWnRwXSvGJt0pMV5kAreqGlyj7aMO5RLHBZK4+CII=";
  };

  package = pkgs.cryptpad.overrideAttrs (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
      mkdir -p "$out/lib/node_modules/cryptpad/lib/plugins/sso"
      cp -R ${ssoPlugin}/. "$out/lib/node_modules/cryptpad/lib/plugins/sso/"
    '';
  });
in
{
  options.jka.services.cryptpad = {
    enable = lib.mkEnableOption "CryptPad collaborative document editing";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "docs.jka.one";
      description = "Primary domain for CryptPad.";
    };

    redirectFrom = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "pad.jka.one" ];
      description = "Domains that redirect to the primary CryptPad domain.";
    };
  };

  config = lib.mkIf cfg.enable {
    jka.services.caddy.enable = true;

    services.caddy.virtualHosts = lib.listToAttrs (
      map (d: {
        name = d;
        value = {
          extraConfig = ''
            redir https://${cfg.domain}{uri}
          '';
        };
      }) cfg.redirectFrom
    ) // {
      "${cfg.domain}" = {
        serverAliases = [ "sandbox.${cfg.domain}" ];
        extraConfig = ''
          encode

          # Main app traffic
          handle /* {
              reverse_proxy localhost:${toString config.services.cryptpad.settings.httpPort}
          }

          # Real-time WebSocket traffic
          handle /cryptpad_websocket {
              reverse_proxy localhost:${toString config.services.cryptpad.settings.websocketPort}
          }
        '';
      };
    };

    services.cryptpad = {
      enable = true;
      inherit package;
      settings = {
        httpSafeOrigin = "https://sandbox.${cfg.domain}";
        httpUnsafeOrigin = "https://${cfg.domain}";
        AppConfig.loginSalt = "9b7c431413375d28f0f881241c0ea3a1693531d2c03af77214eba31ae279e8e8";
        AppConfig.minimumPasswordLength = 8;
      };
    };

    # HACK: Required for SSO to work
    systemd.services.cryptpad = {
      confinement.enable = lib.mkForce false;
      serviceConfig = {
        IPAddressAllow = lib.mkForce [ "any" ];
        IPAddressDeny = lib.mkForce [ ];
      };
    };
  };
}
