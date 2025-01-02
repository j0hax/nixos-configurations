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

    # LSPs and tools
    nil
    taplo
    yaml-language-server
    clang-tools
    texlab
    marksman
    markdown-oxide

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
