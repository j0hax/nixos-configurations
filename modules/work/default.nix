{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.jka.work;
in
{
  options.jka.work = {
    enable = lib.mkEnableOption "work laptop configuration (B1 Systems)";
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.gdm.banner = ''
      Johannes Arnold
      jarnold@b1-systems.de
    '';

    # Disable automatic updates for work laptops
    system.autoUpgrade.enable = false;

    environment.systemPackages = with pkgs; [
      awscli
      zulip
      kemai
      drawio
      gopass
      pwgen
      awscli2
      rustdesk
      squashfsTools
      apache-directory-studio
      marp-cli
      openstackclient-full
      k3s
      openbao
      opencode
    ];

    programs = {
      noisetorch.enable = true;
      openvpn3.enable = true;
    };

    security.pki.certificateFiles = [
      ./DigiCertGlobalRootG2.crt.pem
      ./RapidSSLTLSRSACAG1.crt.pem
    ];
  };
}
