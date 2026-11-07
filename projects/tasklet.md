---
title: Rico's Tasklet (tasklet-clone)
type: project
status: active
repo: https://github.com/rmaviswholesale-create/tasklet-clone
tags: [nextjs, agents, dashboard, self-hosted, loops]
---

# Rico's Tasklet — self-hosted AI agent command center

**Repo:** `rmaviswholesale-create/tasklet-clone` (private). Most active project
in the account. [Source: repo PR history, checked 2026-11-07]

## What it is

A self-hosted, single-user clone of tasklet.ai: marketing landing page plus a
working dashboard (agent runner with SSE streaming, terminal, file browser,
model selector, `/engine` DAG playground), now with Tasklet-parity features.

## Current status: the July backlog is all merged, project is in hardening + automation mode

Every PR that was stuck open in July has landed. Timeline of what shipped:

| When | PR | What |
|---|---|---|
| 2026-07-19 | #1, #2, #3 | CLAUDE.md rewrite + green CI gate; **DeepSeek → OpenRouter provider chain** (Aperture Gateway is now optional legacy) + `/engine` playground + shell-injection fix; dead-code cleanup |
| 2026-08-16 | #4 | **Tasklet parity**: computer use, sandbox, instant apps, planner, memory, triggers |
| 2026-10-25 | #5 | **Security hardening** (red-team pass): default-deny API auth, no wildcard CORS, SSRF-safe `safeFetch`, path-traversal fixes, sandboxed `terminal/exec`, engine bug fixes |
| 2026-10-25 | #6 | `.mcp.json` so cloud/phone sessions start the context-mode MCP server |
| 2026-10-31 | #8, #9 | Fix a test that failed on the 31st; **agent foundation kit** (GOAL.md, specialist agents, verify loop, Stop hook, CI guard) |
| 2026-11-03 | #7, #10 | **Loop engineering**: loop-state, guardrails, and prompts for nightly docs sweep, changelog, coverage goal, CI watcher, repo cleanup |

No open PRs as of 2026-11-07.

## Things to know before touching it

- **Read `GOAL.md` and `CLAUDE.md` first** — they're current now (the old
  "M1 — YOU ARE HERE" banner is gone). `.claude/` holds specialist agents
  (triage, tester, implementer, reviewer), a `fix-issue` pipeline, and a
  `verify-loop`. A Stop hook runs fast checks after code changes and sends
  failures back (max 3 tries).
- `.claude/settings.json` denies force-push, pushes to master/main, PR merges,
  deploys, publishing and `.env` reads — deny rules are a speed bump; branch
  protection on `master` is the real lock.
- Security model: all API routes need `ENGINE_API_TOKEN` in production except
  `/api/health` and `/api/webhook/generic`; files confined to `/tmp/tasklet`.
- Model calls: DeepSeek primary → OpenRouter fallback → optional Aperture.
  Keys in `.env.local` (`DEEPSEEK_API_KEY`, `OPENROUTER_API_KEY`).
- `npm run check` = lint + typecheck + build (what CI runs). ~510 tests pass.

## Known gaps (from the loop-setup PR)

1. Coverage doesn't run — `@vitest/coverage-v8` isn't installed, so the
   coverage loop can't work yet.
2. No coverage target is set in CLAUDE.md for the coverage goal.
3. The nightly routines (docs sweep, changelog, CI watcher) read prompts from
   `master` but **have not been created as scheduled routines** — the prompts
   exist, nothing runs them yet.
4. `LICENSE` still carries the upstream template author's copyright (must stay).

## Definition of done (2026-11-07 baseline)

1. Install `@vitest/coverage-v8`, pick a coverage target, record it in CLAUDE.md.
2. Create the nightly routines from `.claude/loops/` so they actually run.
3. Confirm production deploy is on the post-hardening build: `ENGINE_API_TOKEN`
   set, `/api/health` reachable, an unauthenticated call to another route gets
   401/503.
4. Drive the dashboard end to end once: agent prompt with SSE streaming,
   `/engine` DAG run, file browse, a terminal command.
5. Decide whether to retire the Aperture Gateway dependency entirely.

Do not confuse with `Tasklet_clone` (capital T) — an empty repo.
