{
  config,
  pkgs,
  ...
}:
{
  services.mullvad-vpn = {
    enable = true;
    enableExcludeWrapper = true;
  };

  # We want NetworkManager + encrypted DNS
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
    dns = "systemd-resolved";
  };

  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    dnsovertls = "opportunistic";
    fallbackDns = [
      "1.1.1.1"
      "8.8.8.8"
      "9.9.9.9"
    ];
    llmnr = "true";
    extraConfig = ''
      Domains=~.
      MulticastDNS=true
    '';
  };

  environment.systemPackages = [ pkgs.dnsutils ];
}
