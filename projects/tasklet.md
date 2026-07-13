---
title: Rico's Tasklet (tasklet-clone)
type: project
status: active
repo: https://github.com/rmaviswholesale-create/tasklet-clone
tags: [nextjs, agents, dashboard, aperture, self-hosted]
---

# Rico's Tasklet — self-hosted AI agent command center

**Repo:** `rmaviswholesale-create/tasklet-clone` (private). Most active project
(last push 2026-07-13). [Source: repo README]

## What it is

A self-hosted, single-user clone of tasklet.ai: a marketing landing page plus a
working dashboard with an agent runner (SSE streaming), terminal, file browser,
and model selector. All model calls route through the owner's own **Aperture
Gateway** instance (see `aperture-router` fork) — no SaaS, runs on the owner's
VPS. Production root on the server is `/opt/tasklet-clone/`.

## Stack

- Next.js 16 (App Router) + React 19, TypeScript **strict**, TailwindCSS v4,
  shadcn-style components (`components.json`)
- Vitest (`__tests__/`), ESLint, Docker (`Dockerfile`, `.dev`, `.prod`,
  `docker-compose.yml`), Makefile, `deploy/` scripts
- Node.js 24+ required

## Key entry points

- `src/` — app code; API routes under the App Router:
  `/api/agent/run` (SSE agent execution), `/api/terminal/exec`, `/api/models`,
  `/api/integrations`, `/api/files` (GET/POST/DELETE),
  `/api/browser/screenshot`, `/api/health`
- Config via `.env.local`: `APERTURE_BASE_URL` (points at the owner's Aperture
  Gateway — address in the repo's `.env.example`), `APERTURE_API_KEY`,
  `DEFAULT_MODEL`, `AGENT_TIMEOUT`, `AGENT_MAX_BUFFER`
- Commands: `npm run dev` / `build` / `start` / `lint` / `typecheck`

## Roadmap in the repo's CLAUDE.md

Four milestones: M1 workspace bootstrap + TDD → M2 frontend component tree →
M3 core runtime engine & NL→DAG compiler → M4 swarm layer & MCP
infrastructure. The repo's CLAUDE.md also defines a 60-agent "squad"
convention (`runtime-`, `mcp-`, `task-computer-`, `ui-` prefixes).
[Source: repo CLAUDE.md]

## Gotchas for agents

- The repo is heavily agent-configured (`.claude/`, `.cursor/`, `.clinerules`,
  `AGENTS.md`, …) — read the repo's own CLAUDE.md before editing; it forbids
  placeholders/TODOs and requires strict typing.
- Anything touching agent execution depends on a reachable Aperture Gateway;
  without it, `/api/agent/run` and `/api/models` fail — check `/api/health`
  first when debugging.
- Do not confuse with `Tasklet_clone` (capital T, underscore) — that repo is
  empty.

## Definition of done (2026-07-13 baseline)

Currently at milestone M1 per the repo's own CLAUDE.md. To call this
"complete and working," an agent should be able to check off:

1. `npm run typecheck` and `npm run lint` are clean.
2. `npm test` (Vitest, `__tests__/`) passes.
3. `npm run build` succeeds and `npm run start` boots.
4. `GET /api/health` returns healthy with a **reachable** Aperture Gateway
   (confirm `APERTURE_BASE_URL` in `.env.local` actually resolves first —
   this is the most common silent failure).
5. Manually drive the dashboard at `/dashboard`: run an agent prompt and see
   SSE streaming output, list models via the selector, browse files, run one
   terminal command. All four must work, not just load without erroring.
6. M2 (frontend component tree) and beyond are only "next," not "done" — say
   explicitly which milestone the repo is actually at when reporting status.

