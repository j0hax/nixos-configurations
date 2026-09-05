# NixOS Configurations

> Keep it stateless, stupid.

Configurations for my desktops and servers. Includes secrets management, general services such as automated backups, and dotfile management (via [Home Manager](https://github.com/nix-community/home-manager)).

## Structure

```
flake.nix               # Entry point: defines hosts, inputs, commonModules
hosts/                   # Per-host hardware & host-specific config
  <hostname>/
    configuration.nix
    hardware-configuration.nix
modules/
  system/                # Always-on base (networking, security, restic, etc.)
  desktop/               # Desktop environment, GUI apps, fonts, dev tools
  server/                # Self-hosted services (Caddy, Matrix, Jellyfin, ...)
  work/                  # Work laptop configuration
  user/johannes/         # User account + Home Manager (git, helix, shell, ...)
secrets/                 # SOPS-encrypted secrets
```

All module trees are imported on every host via `commonModules`. Nothing activates unless explicitly enabled through the `jka` option namespace.

## `jka` options

| Option | Description |
|---|---|
| `jka.flakePath` | Path to the flake for `nh` and auto-upgrade (default: `/etc/nixos`) |
| `jka.desktop.enable` | Desktop environment, GUI apps, fonts, dev tools |
| `jka.desktop.gnome.enable` | GNOME desktop |
| `jka.desktop.plasma.enable` | KDE Plasma desktop |
| `jka.desktop.cosmic.enable` | COSMIC desktop |
| `jka.desktop.sway.enable` | Sway window manager |
| `jka.desktop.niri.enable` | Niri compositor with Noctalia |
| `jka.desktop.gaming.enable` | Steam and games |
| `jka.virtualisation.enable` | QEMU/KVM with libvirt |
| `jka.work.enable` | Work laptop packages and config |
| `jka.users.johannes.enable` | Johannes user account + Home Manager (default: `true`) |
| `jka.services.caddy.enable` | Caddy reverse proxy (auto-enabled by services that need it) |
| `jka.services.acme.enable` | ACME certificates via Porkbun DNS |
| `jka.services.auth.enable` | LLDAP + Pocket ID (OIDC) |
| `jka.services.matrix.enable` | Matrix homeserver (tuwunel) |
| `jka.services.xmpp.enable` | XMPP server (Prosody + CoTURN) |
| `jka.services.jellyfin.enable` | Jellyfin media server |
| `jka.services.cryptpad.enable` | CryptPad collaborative documents |
| `jka.services.glance.enable` | Glance dashboard |
| `jka.services.wireguard.enable` | WireGuard VPN (wg-access-server) |
| `jka.services.minecraft.enable` | Minecraft server |
| `jka.services.ntfy.enable` | ntfy push notifications |
| `jka.services.navidrome.enable` | Navidrome music streaming |
| `jka.services.uptime.enable` | Uptime Kuma monitoring |
| `jka.services.bin.enable` | Microbin pastebin |
| `jka.services.ttyd.enable` | ttyd web terminal |
| `jka.services.translate.enable` | LibreTranslate |
| `jka.services.mealie.enable` | Mealie recipe manager |
| `jka.services.audiobookshelf.enable` | Audiobookshelf |
| `jka.services.collabora.enable` | Collabora Online |
| `jka.services.listmonk.enable` | Listmonk mailing lists |

## Hosts

| Host | Arch | Role | Key options |
|---|---|---|---|
| **kirby** | x86_64 | ThinkPad X230 | `desktop`, `gnome` |
| **clay** | x86_64 | MacBook Pro | `desktop`, `gnome` |
| **aptenodytes** | x86_64 | TUXEDO work laptop | `desktop`, `gnome`, `gaming`, `virtualisation`, `work` |
| **kneippweg** | x86_64 | Mac Mini home server | `minecraft` |
| **skylab** | aarch64 | Hetzner ARM VPS | `auth`, `cryptpad`, `glance`, `jellyfin`, `matrix`, `wireguard`, `xmpp` |

## Always-on modules (`modules/system/`)

These are imported unconditionally on every host:

- **restic** -- Daily backups to storage box; hourly Minecraft backups when enabled
- **security** -- SSH on port 484, endlessh honeypot on 22, fail2ban, sudo-rs
- **networking** -- TCP BBR, Quad9/Cloudflare DNS-over-TLS, Yggdrasil mesh
- **maintenance** -- Auto-upgrade with reboot window, garbage collection
- **mta** -- nullmailer for system email
- **containers** -- Podman with Docker compat
- **packages** -- Core CLI tools (ripgrep, htop, neovim, git, fish, etc.)
