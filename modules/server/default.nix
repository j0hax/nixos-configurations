{ pkgs, lib, ... }:
{
  boot.kernelModules = [ "tcp_bbr" ];
}
