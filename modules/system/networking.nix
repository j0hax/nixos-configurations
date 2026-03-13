{
  config,
  pkgs,
  lib,
  ...
}:
let
  yggdrasilPort = 1234;
in
{

  networking = {
    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];

    # Use nftables instead of iptables?
    # nftables.enable = true;

    wireguard.enable = true;
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSOverTLS = "opportunistic";
      DNSSEC = "allow-downgrade";
    };
  };

  programs.arp-scan.enable = true;

  environment.systemPackages = with pkgs; [
    dnsutils
    wireguard-tools
    nmap
  ];

  services.yggdrasil = lib.mkDefault {
    enable = true;
    persistentKeys = true;
    settings.Peers = [
      "quic://skylab.jka.one:1234"
    ];
    openMulticastPort = true;
  };

  systemd = {
    services.yggdrasil-watchdog =
      let
        yggdrasilCheck = pkgs.writeShellScript "yggdrasil-check.sh" ''
          TARGET="ygg.jka.one"

          if ! ${pkgs.iputils}/bin/ping -c 3 -W 30 $TARGET > /dev/null; then
            echo "Yggdrasil connectivity lost, restarting..."
            ${pkgs.systemd}/bin/systemctl restart yggdrasil.service
          fi
        '';
      in
      {
        description = "Restart Yggdrasil if connectivity fails";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = yggdrasilCheck;
        };
      };

    timers.yggdrasil-watchdog = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "2min";
        OnUnitActiveSec = "2min";
        Unit = "yggdrasil-watchdog.service";
      };
    };
  };
}
