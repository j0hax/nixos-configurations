{
  pkgs,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    ripgrep
    silicon

    helix

    nil # Nix LSP
    taplo # TOML tool

    # Go Stuff
    go
    delve
    gopls
    hugo
	
    # Python Stuff
    python3
    python3Packages.python-lsp-server
  ];
}
