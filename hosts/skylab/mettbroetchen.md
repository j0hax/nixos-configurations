---
lang: de-DE
title: Mettbroetchen Minecraft Server
keywords:
- minecraft
---

# Willkommen!

Wir sind ein erweiterter Freundeskreis der einen öffentlichen Vanilla Minecraft SMP-Server betreibt.

Server Adresse: `mettbroetchen.com`

* [Server Status](https://mcstatus.io/status/java/mettbroetchen.com)
* [BigBlueButton](https://b1.b1-athome.de/rooms/ddv-5dq-icj-wuk/join) (Voice Chat)
* [Chat Room](https://matrix.to/#/#mettbroetchen:fiducit.net) (Allgemeiner Chat)

## Regeln

Wir freuen uns über alle, die mit uns kooperativ bauen möchten. Wir brauchen bisher nur eine Regel:

> Sei kein Arschloch. Das beinhaltet Griefing, Spam und jeglicher Fanatismus.

Wir versuchen, das Erlebnis so originalgetreu wie möglich zu gestalten. Daher hat kein Spieler, nicht einmal die Betreiber, `/op` oder andere Sonderrechte.

## Technische Fun Facts

- Automatische Backups erfolgen mehrmals am Tag.
- Als Host-Betriebssysteme verwenden wir [NixOS](https://nixos.org/) mit der aktuellsten verfügbaren Version des [Vanilla Minecraft Server](https://search.nixos.org/packages?channel=unstable&query=minecraft#show=minecraft-server) Paketes.
- Der Server befindet sich im [Yggdrasil](https://yggdrasil-network.github.io/) Netzwerk, ist aber über diese Domäne (mettbroetchen.com) für das offene Internet zugänglich. Hierfür wird der [Caddy](https://caddyserver.com) Server mit dem [L4 Modul](https://github.com/mholt/caddy-l4) verwendet.
- Als Schutz vor automatisierten Port Scans läuft der Server auf einem alternativen Port. Dieser muss aber dank SRV-Records im DNS *nicht* von dir händisch eingetragen werden um zu joinen.
