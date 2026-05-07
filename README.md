# NixOS (Desktop) Configurations

> Keep it stateless, stupid.

Configurations for my desktops and servers. Includes secrets management, general services such as automated backups and dotfile management (via [Home Manager](https://github.com/nix-community/home-manager)).

## Structure
- All hosts are created by the function `mkSystem`, which assigns a common core configuration (host-specific, system, and user configuration alongside [SOPS](https://github.com/getsops/sops)) along with additional, optional modules
- General modules go in `./modules`
- Per-Host configuration is done by `./hosts`

> [!TIP]
> - The `./modules/desktop` directory is a complete desktop setup including shell and additional programs
> - The `./modules/server` directory consists of individual modules used on a case-by-case basis.
