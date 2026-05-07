# NixOS (Desktop) Configurations

[![Modules](https://img.shields.io/badge/dynamic/json?logo=nixos&label=Modules&query=%24.length&url=https%3A%2F%2Fapi.github.com%2Frepos%2Fj0hax%2Fnixos-configurations%2Fcontents%2Fmodules)](/modules)

> Keep it stateless, stupid.

Configurations for my desktops and servers.

Includes secrets management, general services such as automated backups and dotfile management (via [Home Manager](https://github.com/nix-community/home-manager)).

## Structure
- All hosts are created by the function `mkSystem`, which assigns a common core configuration (host-specific, system, and user configuration alongside [SOPS](https://github.com/getsops/sops)) along with additional, optional modules
- General modules go in `./modules`
- Per-Host configuration is done by `./hosts`

> [!TIP]
> - The `./modules/desktop` directory is a complete desktop setup including shell and additional programs
> - The `./modules/server` directory consists of individual modules used on a case-by-case basis.
