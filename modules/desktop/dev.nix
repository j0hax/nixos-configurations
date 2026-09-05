{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.jka.desktop;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nixfmt
      nixpkgs-review
      ripgrep
      gcc
      gnumake
      helix
      yq
      jq
      yamlfmt
      cloc
      hyperfine

      # LSPs and tools
      nil
      taplo
      yaml-language-server
      clang-tools
      texlab
      marksman
      markdown-oxide
      lldb
      shfmt
      shellcheck
      harper
      vscode-css-languageserver
      aider-chat-full

      # Go
      go
      delve
      gopls
      hugo

      # Python
      python3
      python3Packages.python-lsp-server

      # Rust
      rustc
      cargo
      rust-analyzer
      rustfmt
      clippy
    ];
  };
}
