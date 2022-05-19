# NixOS (Desktop) Configurations

[![Modules](https://img.shields.io/badge/dynamic/json?logo=nixos&label=Modules&query=%24.length&url=https%3A%2F%2Fapi.github.com%2Frepos%2Fj0hax%2Fnixos-configurations%2Fcontents%2Fmodules)](/modules)

> Keep it stateless, stupid.

## Features

- Painless per-host `/etc/nixos/` migration
- Distributed builds
- Automagic module import
- Automagic lock file update

## Structure

- General modules go in `./modules`
- Per-Host configuration is done by `./hosts`
