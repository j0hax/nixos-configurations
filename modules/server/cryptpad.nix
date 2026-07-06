{
  pkgs,
  lib,
  config,
  ...
}:
let
  domain = "docs.jka.one";
  sandboxDomain = "sandbox.${domain}";
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
  imports = [ ./caddy.nix ];

  services.caddy.virtualHosts = {
    "pad.jka.one" = {
      extraConfig = ''
        redir https://${domain}{uri}
      '';
    };

    "${domain}" = {
      serverAliases = [ sandboxDomain ];
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
      httpSafeOrigin = "https://${sandboxDomain}";
      httpUnsafeOrigin = "https://${domain}";
      AppConfig.loginSalt = "9b7c431413375d28f0f881241c0ea3a1693531d2c03af77214eba31ae279e8e8";
      AppConfig.minimumPasswordLength = 8;
    };
  };

  # HACK HACK HACK: Required for SSO to work
  systemd.services.cryptpad = {
    confinement.enable = lib.mkForce false;
    serviceConfig = {
      IPAddressAllow = lib.mkForce [ "any" ];
      IPAddressDeny = lib.mkForce [ ];
    };
  };
}
