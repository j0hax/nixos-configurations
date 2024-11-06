{
  config,
  pkgs,
  ...
}:
{
  
  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    ripgrep

    # Best editor???
    helix

    # Go Stuff
    go
    delve
    gopls
    hugo
  ];
}
