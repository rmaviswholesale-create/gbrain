---
title: Shadow / RicoOS (machine archive)
type: project
status: archive
repo: https://github.com/rmaviswholesale-create/Shadow
tags: [archive, ricoos, mcp, backup]
---

# Shadow — archive of the Shadow Tech cloud PC + RicoOS experiments

**Repo:** `rmaviswholesale-create/Shadow` (private). Archive, not an app.

## What it is

A file dump from the owner's **Shadow Tech cloud PC** (a rented Windows
cloud-gaming/desktop machine — the same machine referenced in roklone's setup
docs as `/c/Users/Shadow`). **As of 2026-07, the Shadow subscription is on
hold and the machine is inaccessible** — this repo is the only reachable copy
of what was on it. The owner's active compute is now a Zo Computer
(see [zo-computer.md](zo-computer.md)). Two top-level directories:

- `RicoOS/` — the owner's personal "AI operating system" experiments;
  contains `mcp-servers/antigravity-gateway` (an MCP gateway server)
- `Desktop/` — desktop file backup

## Why it matters

"RicoOS" is the umbrella identity for the owner's personal AI stack (same
"Rico" branding as Rico's Tasklet). Early MCP/gateway experiments here may
predate and explain design choices in `roklone` and `tasklet-clone`.

## Gotchas for agents

- Treat as read-only history. Don't build on this; look here for context or
  to recover old work.
- A machine backup can contain personal files — never quote its contents into
  public artifacts (this gbrain fork is public).
