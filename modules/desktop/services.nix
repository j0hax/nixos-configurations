{ lib, ... }:
{
  hardware = {
    keyboard.qmk.enable = true;
    sane.enable = true;
  };

  services = {
    # Audio
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      #pulse.enable = true;
      audio.enable = true;
      raopOpenFirewall = true;

      extraConfig.pipewire = {
        # AirPlay and Zeroconf Configuration
        "10-zeroconf" = {
          context.modules = [
            {
              "name" = "libpipewire-module-raop-discover";
              "args" = { };
            }
            {
              "name" = "module-zeroconf-discover";
              "args" = { };
            }
            {
              "name" = "module-zeroconf-publish";
              "args" = { };
            }
          ];
        };
      };
    };

    # Device I/O
    udisks2.enable = true;
    # usbmuxd.enable = true;

    # Automatic timezone
    #tzupdate.enable = true;
    automatic-timezoned.enable = true;

    # Enable CUPS to print documents.
    printing.enable = true;
    saned.enable = true;

    mullvad-vpn = {
      enable = true;
      enableExcludeWrapper = true;
    };

    yggdrasil.settings.peers = [ "quic://skylab.jka.one:1234" ];
  };

  # Workaround to split-tunnel Yggdrasil when Mullvad is running
  networking.nftables = lib.mkDefault {
    enable = true;
    tables.yggdrasil = {
      enable = true;
      name = "yggdrasil-mullvad";
      family = "ip6";
      content = ''
        chain output {
          type filter hook output priority 0; policy accept;
          ip6 saddr 200::/7 ip6 daddr 200::/7 ct mark set 0x00000f41 meta mark set 0x6d6f6c65
        }
      '';
    };
  };
}
