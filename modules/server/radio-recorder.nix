{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.jka.services.radio-recorder;

  # File extension for each supported ffmpeg segment muxer
  extensions = {
    mp3 = "mp3";
    adts = "aac";
    ogg = "ogg";
    mpegts = "ts";
  };
in
{
  options.jka.services.radio-recorder = {
    enable = lib.mkEnableOption "background internet radio recording";

    streams = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            url = lib.mkOption {
              type = lib.types.str;
              description = "URL of the radio stream to record.";
            };

            path = lib.mkOption {
              type = lib.types.path;
              description = "Directory that the daily recording files are written to.";
            };

            timezone = lib.mkOption {
              type = lib.types.str;
              default = "Europe/Berlin";
              description = ''
                Timezone of the recording files. A new file is started at 00:00
                local time in this zone.
              '';
            };

            format = lib.mkOption {
              type = lib.types.enum (lib.attrNames extensions);
              default = "mp3";
              description = ''
                ffmpeg segment format matching the stream codec, so the audio
                can be copied without re-encoding. MP3/Icecast streams use
                "mp3", AAC streams (e.g. iHeart revma mounts) use "adts".
              '';
            };
          };
        }
      );
      default = { };
      description = "Internet radio streams to record, keyed by station name.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.radio-recorder = {
      isSystemUser = true;
      group = "radio-recorder";
    };
    users.groups.radio-recorder = { };

    systemd.tmpfiles.rules =
      let
        create = _: stream: "d ${stream.path} 0755 radio-recorder radio-recorder - -";
      in
      lib.mapAttrsToList create cfg.streams;

    systemd.services = lib.mapAttrs' (
      name: stream:
      lib.nameValuePair "radio-recorder-${name}" {

        description = "Record internet radio station ${name}";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        environment = {
          # Recording files and their daily rollover follow this zone
          TZ = stream.timezone;
          # Zoneinfo is only in the system profile when time.timeZone is set
          TZDIR = "${pkgs.tzdata}/share/zoneinfo";
        };

        serviceConfig = {
          User = "radio-recorder";
          Group = "radio-recorder";

          ExecStart = lib.escapeShellArgs [
            "${pkgs.ffmpeg}/bin/ffmpeg"
            "-hide_banner"
            "-nostdin"
            "-loglevel"
            "warning"
            # Recover from temporary connection dropouts
            "-reconnect"
            "1"
            "-reconnect_streamed"
            "1"
            "-reconnect_delay_max"
            "30"
            "-i"
            stream.url
            "-vn"
            "-c:a"
            "copy"
            "-f"
            "segment"
            # One file per day, starting at 00:00 in the configured zone
            "-segment_time"
            "86400"
            "-segment_atclocktime"
            "1"
            "-strftime"
            "1"
            "-segment_format"
            stream.format
            # ExecStart undergoes systemd specifier expansion, where %Y is
            # unknown and %m/%d expand to the machine id and credential dir.
            # Escaping the strftime pattern keeps ffmpeg's own %-formatting.
            "${toString stream.path}/${name}-%%Y-%%m-%%d.${extensions.${stream.format}}"
          ];

          Restart = "always";
          RestartSec = "10s";
          NoNewPrivileges = true;
          PrivateTmp = true;
          ProtectSystem = "strict";
          ReadWritePaths = [ stream.path ];
        };
      }
    ) cfg.streams;
  };
}
