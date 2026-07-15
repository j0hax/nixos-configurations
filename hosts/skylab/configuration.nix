# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

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

  # Use latest kernel.
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # networking.hostName = "skylab"; # Define your hostname.
  networking.domain = "jka.one";
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     tree
  #   ];
  # };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

  services.smartd.enable = false;

  networking = {
    interfaces.enp1s0 = {
      # ipv4.addresses = [
      #   {
      #     address = "188.245.167.251";
      #     prefixLength = 32;
      #   }
      # ];
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
    /*
      "/media/nextcloud" = {
        device = "nextcloud:media";
        fsType = "rclone";
        options = [
          "nodev"
          "nofail"
          "allow_other"
          "args2env"
          "config=/home/johannes/.config/rclone/rclone.conf"
          "vfs_cache_mode=full"
          "cache_dir=/var/cache/rclone"
          "vfs_cache_min_free_space=10G"
        ];
      };
    */

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
        "vfs_cache_mode=full"
        "cache_dir=/var/cache/media"
        "vfs_cache_min_free_space=10G"
        "syslog"
        "v"
      ];
    };
  };

  # Public Yggdrasil peer
  services.yggdrasil.settings = {

    # Configure our this node to listen on TCP and UDP
    Listen = [
      "tcp://0.0.0.0:${toString yggPort}"
      "quic://0.0.0.0:${toString yggPort}"
    ];

    # This VPS is located in southeast Germany, so we peer it with neighboring
    # Yggdrasil nodes. We use TCP to reduce overhead, as it is implemented in the
    # Kernel, unlike QUIC, which is good for general/mobile uses.
    Peers = [
      # Germany/Nuremberg
      "tcp://ygg1.mk16.de:1337?key=0000000087ee9949eeab56bd430ee8f324cad55abf3993ed9b9be63ce693e18a"
      "tcp://ygg2.mk16.de:1337?key=000000d80a2d7b3126ea65c8c08fc751088c491a5cdd47eff11c86fa1e4644ae"

      # Czechia
      "tls://[2a03:3b40:fe:ab::1]:993"
    ];
  };

  # open the respective firewall ports for the above Yggdrasil configurations
  networking.firewall = {
    allowedUDPPorts = [ yggPort ];
    allowedTCPPorts = [ yggPort ];
  };

  # Radio Recording Service
  systemd.services.dlf-record =
    let
      dlf-recorder = pkgs.writeShellScript "dlf-recorder" ''
        exec ${pkgs.ffmpeg}/bin/ffmpeg \
          -reconnect 1 \
          -reconnect_streamed 1 \
          -reconnect_delay_max 10 \
          -re \
          -i 'https://st01.sslstream.dlf.de/dlf/01/high/opus/stream.opus?aggregator=web' \
          -c copy \
          -f segment \
          -segment_atclocktime 1 \
          -segment_time 3600 \
          -strftime 1 \
          -strftime_mkdir 1 \
          './%Y-%m-%d_%H:%M:%S.opus'
      '';
    in
    {
      description = "DLF Recording Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      path = with pkgs; [ ffmpeg ];
      environment.TZ = "Europe/Berlin";

      serviceConfig = {
        Type = "simple";
        WorkingDirectory = "/mnt/media/Radio";
        ExecStart = "${dlf-recorder}";
      };
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
            ' >>"$OUT"
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
    # Yay wedding
    "clara-und-johannes.de" = {
      serverAliases = [ "www.clara-und-johannes.de" ];
      extraConfig = ''
        root * /srv/http/clara-und-johannes.de
        encode zstd gzip
        file_server
      '';
    };

    "arnold.onl" = {
      extraConfig = ''
        handle {
          redir https://johannes.arnold.onl{uri}
        }
      '';
    };

    "radio.jka.one" = {
      extraConfig = ''
        encode
        root /mnt/media/Radio
        file_server browse
      '';
    };

    "gold.jka.one" = {
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

    "fmd.jka.one" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:8080
      '';
    };
  };
}
