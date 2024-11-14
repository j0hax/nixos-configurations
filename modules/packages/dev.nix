{
  pkgs,
  config,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    ripgrep

    # Best editor???
    helix

    nil # Nix LSP

    # Go Stuff
    go
    delve
    gopls
    hugo
  ];
}
