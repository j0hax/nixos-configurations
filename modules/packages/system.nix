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
  ];
}
