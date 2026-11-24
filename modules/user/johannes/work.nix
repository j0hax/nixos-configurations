{
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  cfg = osConfig.jka.work;
in
{
  home.packages = lib.optionals cfg.enable (
    with pkgs;
    [
      # Development
      marp-cli
      apache-directory-studio
      openstackclient-full
      k3s
      k3d
      openbao
      squashfsTools

      # Config management
      ansible
      ansible-lint
      salt-lint

      # Communication
      zulip
      kemai
      teams-for-linux

      # Desktop
      drawio
      rustdesk

      # Infrastructure
      awscli2
      gopass
      pwgen
    ]
  );
}
