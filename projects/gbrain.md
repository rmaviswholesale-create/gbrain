---
title: gbrain (personal knowledge brain)
type: project
status: active
repo: https://github.com/rmaviswholesale-create/gbrain
tags: [memory, retrieval, mcp, cli, fork]
---

# gbrain — the memory layer for everything else

**Repo:** `rmaviswholesale-create/gbrain` — public fork of `garrytan/gbrain`.
This is the repo this registry lives in.

## What it is

A personal knowledge brain + retrieval system: embedded Postgres (PGLite) or
Supabase/pgvector, hybrid search, a ~90-operation contract shared by a CLI
(`gbrain`) and an MCP server, and 30+ agent skills. In the owner's stack it is
the **memory**: every project repo is registered as a gbrain *source* so
agents can `gbrain search` across all of them.

## How the owner uses it

- `scripts/wireup-projects.sh` registers/refreshes the project sources listed
  in `projects/README.md` and syncs them into the brain.
- `projects/` pages (this directory) are brain-tracked (`gbrain.yml`
  `db_tracked`) and sync as first-class pages.
- Claude Code sessions load a "check gbrain first" block from
  `~/.claude/CLAUDE.md` (installed by the wireup script).

## Where the real documentation is

This repo documents itself thoroughly — do not guess:

- `CLAUDE.md` — architecture, invariants, iron rules (always loaded)
- `AGENTS.md` — install + operating protocol for agents
- `docs/architecture/brains-and-sources.md` — the two-axis model
  (brain = which database, source = which repo inside it)
- `skills/RESOLVER.md` — skill dispatcher; read before brain operations

## Gotchas for agents

- **This fork is public.** Never write private details (real names, business
  records, personal matters) into committed files here — brain *content*
  belongs in the database or private repos, not in this repo's git history.
- Follow the upstream contribution rules in CLAUDE.md (version audit, JSONB
  rules, engine parity) when touching engine code.
