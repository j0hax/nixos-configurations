{
  pkgs,
  self,
  lib,
  ...
}:
{
  # Kinda cringe :(
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  # Useful system-wide tools to enable
  programs = lib.mkDefault {
    htop.enable = true;
    iotop.enable = true;
    iftop.enable = true;
    bandwhich.enable = true;
    tcpdump.enable = true;
    tmux.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
    };
    fish = {
      enable = true;
      useBabelfish = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
    ccache.enable = true;
    # flashrom.enable = true;
    gnupg.agent.enable = true;
    # mosh.enable = true;

  };

  environment.systemPackages = with pkgs; [
    uutils-coreutils-noprefix
    # uutils-diffutils
    uutils-findutils

    killall
    pstree
    lsof
    ripgrep
    nix-output-monitor
    tree
    rclone
    bc
    file
    ncdu
    pv
    wget
    usbutils
    pciutils
    smartmontools
    e2fsprogs
    sqlite
    sysstat

    age
    sops

    geoipWithDatabase

    (writeShellScriptBin "mkcache" ''
      if [ -n "$1" ]; then
        dest="$1/CACHEDIR.TAG"
      else
        dest="$(pwd)/CACHEDIR.TAG"
      fi

      dest=$(realpath $dest)

      cat <<EOF > $dest
      Signature: 8a477f597d28d172789f06886806bc55
      # This file is a cache directory tag created by mkcache $dest.
      # For information about cache directory tags, see:
      #	http://www.brynosaurus.com/cachedir/
      EOF

      echo "Created \"$dest\""
    '')

    (writeShellScriptBin "swap" ''
      usage() {
        printf 'Usage: %s <file1> <file2>\n' "$0" >&2
      }

      ensure_exists() {
        [ -e "$1" ] || {
          printf 'Error: %s does not exist\n' "$1" >&2
          usage
          exit 1
        }
      }
      
      if [ "$#" -ne 2 ]; then
        usage
        exit 1
      fi

      a="$1"
      b="$2"

      [ "$(realpath -- "$a")" != "$(realpath -- "$b")" ] || {
        printf 'Error: files must be different\n' >&2
        exit 1
      }

      ensure_exists "$a"
      ensure_exists "$b"

      # Generate a temporary file in the cwd
      tmp=$(mktemp --tmpdir="$(dirname -- "$a")")

      mv -v -- "$a" "$tmp" &&
      {
          # Move b to a, roll back if there is a failure!
          mv -v -- "$b" "$a" ||
          {
              printf 'Error: could not move %s to %s, rolling back!\n' "$b" "$a" >&2
              mv -v -- "$tmp" "$a"
              exit 1
          }
      } &&
      if ! mv -v -- "$tmp" "$a"; then
        printf 'Rollback failed! Original file remains at %s\n' "$tmp" >&2
        exit 2
      fi
    '')
  ];
}
