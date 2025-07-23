{ pkgs, ... }:
{
  systemd.services.restic-rclone-server = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "Start a Restic REST server";
    serviceConfig = {
      Type = "notify";
      ExecStart = ''${pkgs.screen}/bin/screen -dmS irc ${pkgs.irssi}/bin/irssi'';
    };
  }
}
