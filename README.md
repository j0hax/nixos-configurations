# NixOS (Desktop) Configurations

[![Channel](https://img.shields.io/badge/dynamic/json?color=5277c3&label=channel&query=%24.nodes.nixpkgs.original.ref&url=https%3A%2F%2Fraw.githubusercontent.com%2Fj0hax%2Fnixos-configurations%2Fmain%2Fflake.lock&logo=nixos)](https://status.nixos.org/) [![Lock Updated](https://img.shields.io/badge/dynamic/json?color=yellow&label=lock%20updated&query=%24[0].commit.author.date&url=https%3A%2F%2Fapi.github.com%2Frepos%2Fj0hax%2Fnixos-configurations%2Fcommits%3Fper_page%3D1%26path%3D%2Fflake.lock)](/flake.lock) [![Modules](https://img.shields.io/badge/dynamic/json?label=Modules&query=%24.length&url=https%3A%2F%2Fapi.github.com%2Frepos%2Fj0hax%2Fnixos-configurations%2Fcontents%2Fmodules)](/modules)

> Keep it stateless, stupid.

## Features

- Painless per-host `/etc/nixos/` migration
- Distributed builds
- Automagic module import
- Automagic lock file update

## Structure

- General modules go in `./modules`
- Per-Host configuration is done by `./hosts`
