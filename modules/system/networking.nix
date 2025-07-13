{
  config,
  pkgs,
  ...
}:
{

  networking.nameservers = [
    "9.9.9.9"
    "149.112.112.112"
    "2620:fe::fe"
    "2620:fe::9"
  ];

  /*
    Disabled for now:
      "Red Hat does not recommend using [systemd-resolvd] for production."

    services.resolved = {
      enable = true;
      dnssec = "true";
      dnsovertls = "opportunistic";
      fallbackDns = [
        "9.9.9.9#dns.quad9.net"
        "149.112.112.112#dns.quad9.net"
      ];
      domains = [ "~." ];
    };
  */

  environment.systemPackages = [ pkgs.dnsutils ];
}
