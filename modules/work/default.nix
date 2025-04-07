{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    zulip
  ];
}
