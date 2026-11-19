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
- `nix flake check` — CI gate: builds the formatting check for each exposed system only. It does **not** evaluate or build any `nixosConfigurations` host, so a broken host config passes CI. `--no-build` skips building.
- `nixfmt .` / `nixfmt --check .` — format / verify formatting (`nixfmt-rfc-style`; CI uses `--check`).
- `nix build .#nixosConfigurations.<host>.config.system.build.toplevel` — build one host without activating.
- `nh os switch .#<host>` / `nh os boot .#<host>` — build and activate; `nh` defaults to `/etc/nixos`.
- There is no unit-test suite; host evaluation plus formatting is the available verification.

## Module conventions

- Prefer the dendritic pattern: keep each feature in a self-contained module under `modules/`, import module trees globally, and let hosts enable behavior through `jka.*` options instead of importing individual module files.
- Prefer simple, effective solutions over clever abstractions; avoid unnecessary indirection.
- Every module tree is imported on every host via `commonModules` in `flake.nix`. Features activate only through `jka.*` options or explicit host config; a host "not using" a module still evaluates its options.
- Adding a service: create `modules/server/<name>.nix` with `options.jka.services.<name>` and `config = lib.mkIf cfg.enable { ... }`, then add it to the explicit `imports` list in `modules/server/default.nix`. The same explicit-import pattern applies to `modules/system/default.nix` and `modules/desktop/default.nix`.
- Most server modules set `jka.services.caddy.enable` and add `services.caddy.virtualHosts."..."`; follow that pattern for public HTTP services.
- Shared modules must set `jka.*` option values with `lib.mkDefault` (e.g. `jka.services.caddy.enable = lib.mkDefault true;`). Shared modules are imported *after* `hosts/<name>/configuration.nix`, so a plain definition in a module silently beats the host's; `lib.mkDefault` keeps host overrides in `hosts/<name>/configuration.nix` working. The per-host `modules` attrset in `flake.nix` is imported last and wins either way.
- `nixosModules` in `flake.nix` auto-imports only directories under `modules/` that contain a `default.nix`; hosts do not consume modules that way.
- Third-party flake inputs provide NixOS modules: `bootvine` (boot menu, enabled in `modules/system/kernel.nix`) and `mmbridge` (kneippweg only, configured in `hosts/kneippweg/configuration.nix`); both are wired into `commonModules`/host modules, not `nixosModules`.
- Home Manager config is under `modules/user/johannes/` and is enabled by default. It is imported explicitly in `home.nix`; add new user modules to that `imports` list.
- Applications belong in Home Manager (`modules/user/johannes/dev.nix`, `desktop.nix`, `work.nix`), not `environment.systemPackages`. System modules keep services, drivers, codecs and packages other modules/programs depend on (e.g. `mpv` for codecs, `guestfs-tools`, `rclone`).
- Home-manager modules can read NixOS settings via the `osConfig` argument. User modules gate on `osConfig.jka.desktop.enable`, `osConfig.jka.desktop.packages.*` (which default to the corresponding `jka.desktop.<de>.enable`), and `osConfig.jka.work.enable`; `work.nix` has no NixOS counterpart, so `osConfig.jka.work.enable` is its only gate.
- Host-level desktop/work/service choices usually live in `flake.nix`; host-specific hardware and one-off settings live in `hosts/<name>/configuration.nix`.
- Treat `flake.nix` and the `options.jka.*` definitions as source of truth; `README.md` is descriptive and can lag behind modules.

## Secrets

- sops-nix is used with default file `secrets/secrets.yaml` and the host SSH key at `/etc/ssh/ssh_host_ed25519_key`.
- For non-default secret files, declare `sopsFile` and `format` (`yaml`, `dotenv`, `ini`, etc.) per secret, as in `modules/server/auth.nix` or `modules/server/restic.nix`.
- `.sops.yaml` creation rules match flat `secrets/<name>.<ext>` paths only. Adding a host requires adding its age key there and running `sops updatekeys <file>` on affected secrets.
- Never print or commit decrypted secret values; edit ciphertext with `sops secrets/<file>`.

## Gotchas

- Flakes only see git-tracked files. `git add` new modules or host files before `nix flake check`/build, otherwise Nix evaluates the older tree.
- `modules/desktop/default.nix` sets `boot.kernelPackages` with `lib.mkDefault`, so hosts may define it plainly (as `hosts/clay/configuration.nix` does). CI won't catch host-level eval errors: `nix flake check` doesn't evaluate hosts, so verify with `nix build .#nixosConfigurations.<host>.config.system.build.toplevel` before deploying.
- Building a home-manager profile surfaces conflicts that system profiles hide: two packages providing the same binary fail the build with "conflicting subpath" (e.g. `awscli` and `awscli2` both provide `aws`). Check `home.packages` for duplicates before adding.
- `nix eval` refuses unfree/insecure packages; `nix build` does not. Evaluate packages with `nix build --no-link` to match what deployment will do.
- Modules reference non-Nix assets by relative path: matrix avatars live in `modules/server/*.svg` and work root CAs in `modules/work/*.crt.pem`. Don't treat these as stray files.
- Home-manager man-page caching forces every `home.packages` entry on every host, so desktop-only packages marked unavailable on aarch64 (e.g. `spotify`) must be guarded by platform, or `skylab` fails to evaluate.
- `pkgs.unstable` is the `nixos-unstable-small` overlay from `flake.nix`.
- Changing Caddy plugins in `modules/server/caddy.nix` requires updating its `hash`; the build error prints the expected value.
- Don't change a host's `system.stateVersion` as part of unrelated work.
