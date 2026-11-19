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
  desktop/               # Desktop environments (GNOME, Plasma, Sway), fonts, program options
  server/                # Self-hosted services (Caddy, Matrix, Jellyfin, ...)
  work/                  # Work laptop configuration
  user/johannes/         # User account + Home Manager (git, helix, shell, dev, desktop, work apps)
secrets/                 # SOPS-encrypted secrets
```

All module trees are imported on every host via `commonModules`. Nothing activates unless explicitly enabled through the `jka` option namespace.

Applications Johannes uses (desktop apps, development tools, work programs) are installed through Home Manager, not `environment.systemPackages`. System modules keep only what the system itself needs: services, drivers, codecs and packages other modules depend on.

## `jka` options

| Option | Description |
|---|---|
| `jka.nix.flakePath` | Path to the flake for `nh` and auto-upgrade (default: `/etc/nixos`) |
| `jka.desktop.enable` | Desktop environment, fonts, GUI program options |
| `jka.desktop.gnome.enable` | GNOME desktop |
| `jka.desktop.plasma.enable` | KDE Plasma desktop |
| `jka.desktop.cosmic.enable` | COSMIC desktop |
| `jka.desktop.sway.enable` | Sway window manager |
| `jka.desktop.gaming.enable` | Steam and games |
| `jka.desktop.packages.enable` | Install desktop applications in the user profile (default: `jka.desktop.enable`) |
| `jka.desktop.packages.gnome` | GNOME applications (default: `jka.desktop.enable && jka.desktop.gnome.enable`) |
| `jka.desktop.packages.plasma` | Plasma applications (default: `jka.desktop.enable && jka.desktop.plasma.enable`) |
| `jka.desktop.packages.sway` | Sway utilities (default: `jka.desktop.enable && jka.desktop.sway.enable`) |
| `jka.desktop.packages.gaming` | Games (default: `jka.desktop.enable && jka.desktop.gaming.enable`) |
| `jka.virtualisation.enable` | QEMU/KVM with libvirt |
| `jka.work.enable` | Work laptop config and work applications |
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
| `jka.services.redis.enable` | Redis (Valkey) |
| `jka.services.restic-server.enable` | Restic REST backup server (rclone) |
| `jka.services.warpgate.enable` | Warpgate SSH bastion |

## Hosts

| Host | Arch | Role | Key options |
|---|---|---|---|
| **kirby** | x86_64 | ThinkPad X230 | `desktop`, `gnome` |
| **clay** | x86_64 | MacBook Pro | `desktop`, `gnome` |
| **aptenodytes** | x86_64 | TUXEDO work laptop | `desktop`, `gnome`, `gaming`, `virtualisation`, `work` |
| **kneippweg** | x86_64 | Mac Mini home server | `minecraft` |
| **skylab** | aarch64 | Hetzner ARM VPS | `auth`, `cryptpad`, `glance`, `jellyfin`, `matrix`, `restic-server`, `wireguard` |

## Always-on modules (`modules/system/`)

These are imported unconditionally on every host:

- **restic** -- Daily backups to storage box; Minecraft backups every 4 hours when enabled
- **security** -- SSH on port 484, endlessh honeypot on 22, fail2ban, sudo-rs
- **networking** -- TCP BBR, Quad9/Cloudflare DNS-over-TLS, Yggdrasil mesh
- **kernel** -- bootvine boot menu, Btrfs, `perf`; `mitigations=off` only on desktop hosts
- **maintenance** -- Auto-upgrade with reboot window, garbage collection
- **mta** -- nullmailer for system email
- **containers** -- Podman with Docker compat
- **packages** -- System CLI tools and editors (htop, neovim, git, fish, etc.); interactive tools such as ripgrep, fd and btop come from the user profile (`modules/user/johannes/packages.nix`) so servers get them too
