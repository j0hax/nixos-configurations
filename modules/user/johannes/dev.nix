{
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  isDesktop = osConfig.jka.desktop.enable;
in
{
  home.packages = lib.optionals isDesktop (
    with pkgs;
    [
      # General tools
      ripgrep
      fd
      gnumake
      cloc
      hyperfine
      openssl
      xxd
      tree

      # Nix
      nixfmt
      nixpkgs-review
      nil
      nixd
      nix-output-monitor

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

      # Containers
      podman-tui
      podman-compose
      podlet

      # Coding agents
      unstable.opencode
      unstable.pi-coding-agent
      unstable.crush
    ]
  );
}
