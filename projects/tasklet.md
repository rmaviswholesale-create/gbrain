---
title: Rico's Tasklet (tasklet-clone)
type: project
status: active
repo: https://github.com/rmaviswholesale-create/tasklet-clone
tags: [nextjs, agents, dashboard, aperture, self-hosted]
---

# Rico's Tasklet — self-hosted AI agent command center

**Repo:** `rmaviswholesale-create/tasklet-clone` (private). Most active project
in the whole account. [Source: repo commits + open PRs, checked 2026-07-18]

## What it is

A self-hosted, single-user clone of tasklet.ai: a marketing landing page plus a
working dashboard with an agent runner (SSE streaming), terminal, file browser,
and model selector.

## Real status: further along than the docs say — read the PRs, not just CLAUDE.md

The repo's own `CLAUDE.md` still says "M1: Workspace Bootstrap ← YOU ARE HERE"
— **that's stale.** The commit log shows all four milestones (M1–M4) shipped
by 2026-07-02, followed by a "v1.1: 60-agent swarm complete" commit: 19 API
routes (up from 6), mobile-responsive dashboard, real Gmail/Calendar/Drive
integration, e2e tests, and production infra (process manager, backups,
health monitoring, rate limiting). Don't trust the milestone banner — check
`git log` or the open PRs below for the real state.

## ⚠️ Three open, unmerged, unreviewed PRs (this is the actual todo list)

All three are drafts sitting on `master`, all Claude-Code-generated, all
still open as of 2026-07-18:

| PR | What it does | Status |
|---|---|---|
| [#1](https://github.com/rmaviswholesale-create/tasklet-clone/pull/1) | Rewrites the stale CLAUDE.md + fixes a **red CI gate** (41 ESLint errors, 27 tsc errors on `master` itself) | Draft, open since 07-08 |
| [#2](https://github.com/rmaviswholesale-create/tasklet-clone/pull/2) | **Removes the hardcoded Aperture Gateway dependency.** Adds a DeepSeek→OpenRouter provider failover chain using the owner's own API keys, a new `/engine` DAG-visualization playground, and a security fix (replaced a shell `execSync` curl with validated `fetch` — closes a shell-injection risk) | Draft, open since 07-11 |
| [#3](https://github.com/rmaviswholesale-create/tasklet-clone/pull/3) | Cleanup pass on top of #1/#2: dead code removal, de-duplication, stronger typing | Draft, open since 07-12 |

**These three build on each other** (#1 fixes the CI gate everything else
needs; #2 is the architecture change; #3 cleans up after). Landing them, in
that order, is higher leverage than any other work on this repo right now —
until they merge, `master` still has broken CI and the old hardcoded-gateway
dependency.

## Stack

- Next.js 16 (App Router) + React 19, TypeScript **strict**, TailwindCSS v4,
  shadcn-style components (`components.json`)
- Vitest, ESLint, Docker, PM2 process management, Tailscale Funnel for
  public access, daily backups
- Node.js 24+ required

## Key entry points

- `src/` (app layer) vs top-level `lib/` (platform engine) — see PR #1's
  rewritten CLAUDE.md for the split, once merged
- 19 API routes as of v1.1: agent run (SSE), chat completions proxy, terminal
  exec, file CRUD, browser screenshot, health, models, integrations (+
  connect), dashboard stats, logs, tools list, webhooks, Gmail
  search/send, Calendar list/create, Drive list
- After PR #2: model calls go through **DeepSeek (primary) → OpenRouter
  (fallback) → legacy Aperture (optional)** instead of a single hardcoded
  gateway — configure `DEEPSEEK_API_KEY` / `OPENROUTER_API_KEY` in
  `.env.local`
- Commands: `npm run dev` / `build` / `start` / `lint` / `typecheck` /
  `npm run check` (all three combined — this is what CI runs)

## Gotchas for agents

- The repo is heavily agent-configured (`.claude/`, `.cursor/`, `.clinerules`,
  `AGENTS.md`, …) — read the repo's own CLAUDE.md before editing (but verify
  it against PR #1 first — the one on `master` is stale).
- Before assuming the Aperture Gateway is required, check whether PR #2 has
  merged — post-merge, DeepSeek/OpenRouter is primary and Aperture is
  optional legacy.
- Do not confuse with `Tasklet_clone` (capital T, underscore) — that repo is
  empty.

## Definition of done (2026-07-18 baseline)

1. **Review and merge PR #1** — it's the CI fix everything else depends on.
   Nothing else on this repo can show a green check until this lands.
2. **Review and merge PR #2** — biggest architectural decision pending: moving
   off a hardcoded Aperture Gateway onto the owner's own DeepSeek/OpenRouter
   keys, plus a real security fix (shell injection). Worth reading closely,
   not rubber-stamping.
3. **Review and merge PR #3** — cleanup, lowest risk of the three, land last.
4. After all three land: `npm run check` clean on `master`, `/api/health`
   returns healthy, and manually drive the dashboard — run an agent prompt
   and watch SSE stream, list models, browse files, run one terminal command,
   and (if #2 merged) try the new `/engine` DAG playground.
5. Decide what happens to the Aperture Gateway dependency long-term once #2
   is evaluated — keep as fallback, or retire it from the stack entirely.
