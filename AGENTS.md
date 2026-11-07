# AGENTS.md

Nix flake for Johannes' NixOS hosts and Home Manager config. `main` is the deployment branch, and this checkout is the live flake at `/etc/nixos` (`jka.flakePath`, used by `nh` and auto-upgrade). Switching here changes the running machine.

## Hosts

Hosts are defined in `flake.nix` under `systems`; each has `hosts/<name>/configuration.nix` plus a generated `hardware-configuration.nix`.

| Host | Platform | Role |
|---|---|---|
| `kirby` | x86_64 | ThinkPad X230 |
| `clay` | x86_64 | MacBook Pro |
| `aptenodytes` | x86_64 | TUXEDO work laptop |
| `kneippweg` | x86_64 | Mac Mini home server |
| `skylab` | aarch64 | Hetzner ARM VPS |

## Commands

- `nix develop` — dev shell with `nixfmt`, `nil`, `sops`, `age`, `ssh-to-age`.
- `nix flake check` — CI gate: evaluates every `nixosConfigurations` host and builds the formatting check. `--no-build` skips building.
- `nixfmt .` / `nixfmt --check .` — format / verify formatting (`nixfmt-rfc-style`; CI uses `--check`).
- `nix build .#nixosConfigurations.<host>.config.system.build.toplevel` — build one host without activating.
- `nh os switch .#<host>` / `nh os boot .#<host>` — build and activate; `nh` defaults to `/etc/nixos`.
- There is no unit-test suite; host evaluation plus formatting is the available verification.

## Module conventions

- Every module tree is imported on every host via `commonModules` in `flake.nix`. Features activate only through `jka.*` options or explicit host config; a host "not using" a module still evaluates its options.
- Adding a service: create `modules/server/<name>.nix` with `options.jka.services.<name>` and `config = lib.mkIf cfg.enable { ... }`, then add it to the explicit `imports` list in `modules/server/default.nix`. The same explicit-import pattern applies to `modules/system/default.nix` and `modules/desktop/default.nix`.
- Most server modules set `jka.services.caddy.enable = true` and add `services.caddy.virtualHosts."..."`; follow that pattern for public HTTP services.
- `nixosModules` in `flake.nix` auto-imports only directories under `modules/` that contain a `default.nix`; hosts do not consume modules that way.
- Home Manager config is under `modules/user/johannes/` and is enabled by default.
- Host-level desktop/work/service choices usually live in `flake.nix`; host-specific hardware and one-off settings live in `hosts/<name>/configuration.nix`.
- Treat `flake.nix` and the `options.jka.*` definitions as source of truth; `README.md` is descriptive and can lag behind modules.

## Secrets

- sops-nix is used with default file `secrets/secrets.yaml` and the host SSH key at `/etc/ssh/ssh_host_ed25519_key`.
- For non-default secret files, declare `sopsFile` and `format` (`yaml`, `dotenv`, `ini`, etc.) per secret, as in `modules/server/auth.nix` or `modules/server/restic.nix`.
- `.sops.yaml` creation rules match flat `secrets/<name>.<ext>` paths only. Adding a host requires adding its age key there and running `sops updatekeys <file>` on affected secrets.
- Never print or commit decrypted secret values; edit ciphertext with `sops secrets/<file>`.

## Gotchas

- Flakes only see git-tracked files. `git add` new modules or host files before `nix flake check`/build, otherwise Nix evaluates the older tree.
- `modules/desktop/default.nix` sets `boot.kernelPackages` without `lib.mkDefault`; host overrides need `lib.mkForce`. `hosts/clay/configuration.nix` currently defines it again, so `nix flake check` fails evaluating `clay` with "defined multiple times".
- `pkgs.unstable` is the `nixos-unstable-small` overlay from `flake.nix`.
- Changing Caddy plugins in `modules/server/caddy.nix` requires updating its `hash`; the build error prints the expected value.
- Don't change a host's `system.stateVersion` as part of unrelated work.
