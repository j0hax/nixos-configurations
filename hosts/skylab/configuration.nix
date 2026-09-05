{
  config,
  lib,
  pkgs,
  ...
}:

let
  yggPort = 1234;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.domain = "jka.one";

  system.stateVersion = "25.05"; # Did you read the comment?

  services.smartd.enable = false;
  services.journald.storage = "volatile";

  networking = {
    interfaces.enp1s0 = {
      ipv6.addresses = [
        {
          address = "2a01:4f8:1c17:70c2::1";
          prefixLength = 64;
        }
      ];
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "enp1s0";
    };
  };

  services.spice-vdagentd.enable = true;
  environment.systemPackages = with pkgs; [
    rclone
    yt-dlp-light
  ];

  fileSystems."/".options = [
    "compress=zstd"
    "autodefrag"
  ];

  sops.secrets.rclone = {
    sopsFile = ../../secrets/rclone-system.ini;
    format = "ini";
  };

  fileSystems = {
    "/mnt/media" = {
      device = "media:";
      fsType = "rclone";
      options = [
        # Prevent system from hanging at boot
        "noauto"
        "nofail"
        "x-systemd.automount"
        "_netdev"

        # Standard options
        "allow_other"
        "args2env"
        "config=${config.sops.secrets.rclone.path}"
        "vfs-cache_mode=full"
        "cache-dir=/var/cache/media"
        "vfs-cache-max-size=10G"
        "syslog"
        "v"
      ];
    };
  };

  # Public Yggdrasil peer
  services.yggdrasil.settings = {

    # Configure this node to listen on TCP and QUIC
    Listen = [
      "tcp://0.0.0.0:${toString yggPort}"
      "quic://0.0.0.0:${toString yggPort}"
    ];

    # This VPS is located in southeast Germany, so we peer it with neighboring
    # Yggdrasil nodes. We use TCP/TLS to reduce overhead, as it is implemented in the
    # Kernel, unlike QUIC, which is good for general/mobile uses.
    Peers = [
      # Germany/Nuremberg
      "tcp://ygg1.mk16.de:1337?key=0000000087ee9949eeab56bd430ee8f324cad55abf3993ed9b9be63ce693e18a"
      "tcp://ygg2.mk16.de:1337?key=000000d80a2d7b3126ea65c8c08fc751088c491a5cdd47eff11c86fa1e4644ae"

      # Germany/Frankfurt
      "tcp://ip4.fvm.mywire.org:8080?key=000000000143db657d1d6f80b5066dd109a4cb31f7dc6cb5d56050fffb014217"
      "tcp://ip6.fvm.mywire.org:8080?key=000000000143db657d1d6f80b5066dd109a4cb31f7dc6cb5d56050fffb014217"

      # Netherlands/Kerkrade
      "tcp://cirno.nadeko.net:44441"

      # Austria/Vienna
      "tcp://ygg7.mk16.de:1337?key=000000086278b5f3ba1eb63acb5b7f6e406f04ce83990dee9c07f49011e375ae"

      # Czechia/Prague
      "tls://[2a03:3b40:fe:ab::1]:993?key=0009e16b9e3afe7b13c3612560410434d3dfc70c8a8a0a63e51e0470cb8124f6"
    ];
  };

  # Open the respective firewall ports for the above Yggdrasil configurations
  networking.firewall = {
    allowedUDPPorts = [ yggPort ];
    allowedTCPPorts = [ yggPort 1902 ];
  };

  # Minecraft proxy: open internet <-> kneippweg over Yggdrasil
  services.haproxy = {
    enable = true;

    config = ''
      global
        log stdout format raw local0

      defaults
        mode tcp
        log global
        option tcplog
        retries 3
        timeout connect 10s
        timeout client  1h
        timeout server  1h
        timeout tunnel  24h

      frontend minecraft
        bind [::]:1902 v4v6
        default_backend minecraft_backend

      backend minecraft_backend
        server kneippweg kneippweg.ygg.jka.one:25565
    '';
  };

  # Gold Price Recording Service
  systemd.services.degussa-tracker =
    let
      script = pkgs.writeShellApplication {
        name = "degussa";
        runtimeInputs = with pkgs; [
          curl
          jq
          pup
        ];
        text = ''
          OUT="prices.csv"
          LIGHT="krugerrand.csv"

          html=$(curl -fsSL https://degussa.com/de-de/header_navigation/preise/preisliste/)
          timestamp=$(date --iso-8601=seconds)

          printf '%s' "$html" |
          	pup 'a.priceListTableRow json{}' |
          	jq -r --arg ts "$timestamp" '
              .[] |
              (.children | map(.text // "" | gsub("^\\s+|\\s+$"; ""))) as $f |
              [
                $ts,
                $f[0],
                $f[2],
                (
                  $f[3]
                  | gsub("[^0-9,.]"; "")
                  | gsub("\\."; "")
                  | gsub(","; ".")
                ),
                (
                  $f[4]
                  | gsub("[^0-9,.]"; "")
                  | gsub("\\."; "")
                  | gsub(","; ".")
                )
              ] |
              flatten |
              @csv
            ' |
            tee -a "$OUT" |
            grep -F '"1 oz Krügerrand Goldmünze - Südafrika 2026"' >> "$LIGHT"
        '';
      };
    in
    {
      description = "Degussa gold price scraper";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment.TZ = "Europe/Berlin";

      serviceConfig = {
        Type = "oneshot";
        WorkingDirectory = "/var/lib/degussa";
        ExecStart = "${script}/bin/degussa";
      };
    };

  systemd.timers.degussa-tracker = {
    description = "Update Degussa price tracker";

    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "*:0/5";
      Unit = "degussa-tracker.service";
    };
  };

  # Ensure goldprice data is present
  systemd.tmpfiles.rules = [
    "d /var/lib/degussa 0755 root root -"
  ];

  services.caddy.virtualHosts = {

    "arnold.onl" = {
      extraConfig = ''
        handle {
          redir https://johannes.arnold.onl{uri}
        }
      '';
    };

    "gold.jka.one" = {
      serverAliases = [ "gold.arnold.onl" ];
      extraConfig = ''
        encode
        root /var/lib/degussa
        file_server browse
      '';
    };

    "johannes.contact" = {
      extraConfig = ''
        root * /srv/http/johannes.contact
        encode zstd gzip
        file_server
        try_files johannes.vcf
      '';
    };

    "status.jka.one" = {
      serverAliases = [ "status.ksh.jka.one" ];
      extraConfig = ''
        encode
        cache

        @ksh host status.ksh.jka.one
        redir @ksh https://status.jka.one{uri} permanent

        reverse_proxy kneippweg.ygg.jka.one:4000
      '';
    };

    "mettbroetchen.com" = {
      extraConfig = ''
        redir https://mcstatus.io/status/java/mettbroetchen.com
      '';
    };
  };
}
