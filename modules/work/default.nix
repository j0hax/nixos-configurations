{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    zulip
    kemai
  ];
}
