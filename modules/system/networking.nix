{
  config,
  pkgs,
  ...
}:
{

  networking = {
    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];

    # Use nftables instead of iptables
    nftables.enable = true;

    wireguard.enable = true;
  };

  services.resolved = {
    enable = true;
    dnsovertls = "opportunistic";
    domains = [ "~." ];
  };

  environment.systemPackages = with pkgs; [
    dnsutils
    wireguard-tools
  ];
}
