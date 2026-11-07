---
title: roklone (Zo Computer clone)
type: project
status: active
repo: https://github.com/rmaviswholesale-create/roklone
tags: [mcp, providers, docker, self-hosted, loops]
---

# roklone — self-hosted "Zo Computer" clone (chat + MCP tool server)

**Repo:** `rmaviswholesale-create/roklone` (private). [Source: repo PR history,
checked 2026-11-07]

## What it is

A self-hosted agent/chat environment modeled on Zo Computer: Express/TypeScript
server with a web UI (conversation history, model + persona pickers), a tool
server (bash, filesystem, memory, Playwright), and an MCP stdio surface.

## Current status: v2 shipped, now model-agnostic, deployable, CI-covered

The old "mid-debug, hardcoded secrets" state is gone. What landed:

| When | PR | What |
|---|---|---|
| 2026-07-19 | #1 | **v2 revamp**: provider-routed chat, hardcoded Gemini key and UI token removed, 43 tests, Docker + `render.yaml` free hosting |
| 2026-10-28→11-03 | #2 | **Model-agnostic provider layer**: config-driven catalog with env overrides; **DeepSeek and OpenRouter** via an OpenAI-compatible fetch adapter; models listed only when their key is set; upstream errors never leak keys (74 tests) |
| 2026-10-31 | #5 | Agent foundation kit (GOAL.md from SPEC.md, specialist agents, verify loop, Stop hook) + **first CI workflow** |
| 2026-11-03 | #3 | `.mcp.json` so cloud sessions start context-mode |

Also: 12 tracked v1 debug artifacts were deleted, a `LATER.md` parking lot
holds deferred ideas, and a `coding-workflow` skill + `/workflow` command exist.

## Open item

- **PR #4** (draft, since 2026-10-28): "Add context-mode MCP config for cloud
  sessions" — superseded by merged PR #3 doing the same thing. Close it.

## Things to know

- Read `GOAL.md`, `SPEC.md`, `CLAUDE.md` first; acceptance criteria in SPEC.md
  map 1:1 to tests.
- `scripts/smoke-live.sh` runs one real completion per configured provider —
  use it after setting keys.
- Secrets live in env only; never commit keys. The bash/file tools give an
  agent full machine access, so keep token auth intact.
- Deploy path: `render.yaml` (Render free plan) or Docker (`3333:3000`).

## Definition of done (2026-11-07 baseline)

1. Close superseded draft PR #4.
2. Deploy the current `main` (Render or Zo), set at least one provider key,
   run `scripts/smoke-live.sh`, confirm `/health` and an authenticated chat.
3. Confirm unauthenticated requests get 401.
4. Triage `LATER.md` — promote anything worth building into SPEC.md.
