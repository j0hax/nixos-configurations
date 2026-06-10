{ pkgs, lib, ... }:
{
  # Add banner
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
    # shell-gpt
    gopass
    teams-for-linux
    zoom-us
    pwgen
    awscli2
    rustdesk
    squashfsTools
    apache-directory-studio
    marp-cli
  ];

  programs = {
    noisetorch.enable = true;
    openvpn3.enable = true;
  };

  security.pki.certificateFiles = [
    ./DigiCertGlobalRootG2.crt.pem
    ./RapidSSLTLSRSACAG1.crt.pem
  ];
}
