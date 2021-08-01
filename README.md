# NixOS Configurations

![Channel](https://img.shields.io/badge/dynamic/json?color=5277c3&label=channel&query=%24.nodes.nixpkgs.original.ref&url=https%3A%2F%2Fraw.githubusercontent.com%2Fj0hax%2Fnixos-configurations%2Fmain%2Fflake.lock&logo=nixos) ![Lock Updated](https://img.shields.io/badge/dynamic/json?color=yellow&label=lock%20updated&query=%24[0].commit.author.date&url=https%3A%2F%2Fapi.github.com%2Frepos%2Fj0hax%2Fnixos-configurations%2Fcommits%3Fper_page%3D1%26path%3D%2Fflake.lock) ![Modules](https://img.shields.io/badge/dynamic/json?label=Modules&query=%24.length&url=https%3A%2F%2Fapi.github.com%2Frepos%2Fj0hax%2Fnixos-configurations%2Fcontents%2Fgeneral)

> Keep it stateless, stupid.

## Module Overview
| Module | Purpose |
| ------ |---------|
| `environment` | Sets environment variables and shell behavior |
| `maintenance` | Automatically maintain system, such as garbage collection |
| `packages` | Desktop Applications to be installed for all users |
| `system` | System Options such as daemons, users, etc. |
