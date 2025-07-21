{
  pkgs,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    ripgrep
    silicon
    gcc
    helix
    yq
    jq
    yamlfmt

    # LSPs and tools
    nil
    taplo
    yaml-language-server
    clang-tools
    texlab
    marksman
    markdown-oxide
    lldb

    # Go Stuff
    go
    delve
    gopls
    hugo

    # Python Stuff
    python3
    python3Packages.python-lsp-server

    # Rust Stuff
    rustc
    cargo
    rust-analyzer
    rustfmt
    clippy
  ];
}
