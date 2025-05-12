{
  ...
}:
{
  # Generally useful services.
  services = {
    locate.enable = true;
    fwupd.enable = true;
    openssh.enable = true;
    tuptime.enable = true;
    smartd.enable = true;
    tor = {
      enable = true;
      client.enable = true;
      torsocks.enable = true;
    };
  };
}
