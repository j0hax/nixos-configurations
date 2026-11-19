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
      # General tools
      ripgrep
      gnumake
      helix
      cloc
      hyperfine
      openssl
      xxd

      # Nix
      nixfmt
      nixpkgs-review
      nil
      nixd

      # TOML
      taplo

      # YAML
      yaml-language-server
      yamlfmt
      yq

      # JSON
      jq

      # C / C++
      gcc
      clang-tools
      lldb

      # Shell
      shfmt
      shellcheck

      # LaTeX
      texlab

      # Markdown
      marksman
      markdown-oxide
      harper

      # CSS
      vscode-css-languageserver

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

      # PHP
      php
      intelephense
      phpPackages.composer

      # JavaScript
      nodejs

      # Coding agents
      unstable.opencode
      unstable.pi-coding-agent
      unstable.crush
    ];
  };
}
