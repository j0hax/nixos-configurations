{
  pkgs,
  config,
  ...
}:
{
  # Useless must-haves
  environment.systemPackages = with pkgs; [
    cbonsai
    cmatrix
    pipes-rs
    tty-clock
    fastfetch
  ];
}
