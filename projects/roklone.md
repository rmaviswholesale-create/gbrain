---
title: roklone (Zo Computer clone)
type: project
status: wip
repo: https://github.com/rmaviswholesale-create/roklone
tags: [mcp, tools, docker, playwright, self-hosted]
---

# roklone — self-hosted "Zo Computer" clone (MCP tool server)

**Repo:** `rmaviswholesale-create/roklone` (private). WIP. [Source: repo SETUP.md]

## What it is

A self-hosted agentic environment modeled on Zo Computer (see the `Zo` fork):
a Node/TypeScript server exposing **~107 tools** — bash execution, filesystem,
memory (fact storage), Playwright browser automation, and integrations
(GitHub, Slack, Notion, OpenAI, Anthropic) — over two surfaces:

1. **HTTP API** on port 3000 (`/health`, `/tools`, `POST /tools/<name>`),
   Bearer-token auth via `MCP_TOKEN`
2. **MCP stdio server** (`dist/index.js`) for Claude Desktop / Cursor

## Stack & layout

- Node 20+, TypeScript (`npm run build` → `dist/`), Express-style HTTP server
- Docker-first: `docker-compose.yml` (with optional postgres/redis services,
  optional Docker-socket mount for Docker tools via `DOCKER_ENABLED=1`)
- `src/` (tools live in `src/tools/`), `web/` (frontend), `skills/` dir
- The **real documentation is `CLAUDE.md` (~24KB)** — the README is a
  placeholder (24 bytes). Read CLAUDE.md first.

## Status signals

Committed debug artifacts (`build_err.txt`, `dev_err.txt`, `start_err.txt`,
`test_gemini_*.js`, `models_list.json`) show mid-debugging state, including
Gemini API experiments. Expect the build to possibly be broken; check
`build_err.txt` / `start_err.txt` for the last known failures before assuming
a fresh bug.

## Origin note

Developed on the Windows PC named "Shadow" (`/c/Users/Shadow/Projects/
zo-computer-clone`) — same machine whose files are archived in the `Shadow`
repo.

## Gotchas for agents

- Secrets go in `.env` (`MCP_TOKEN`, `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`,
  `GITHUB_TOKEN`, `SLACK_BOT_TOKEN`, `NOTION_API_KEY`) — never commit them.
- Bash/file tools give an agent full machine access — keep resource limits and
  the token auth intact when editing.
- Browser-tool failures usually mean Playwright needs a container rebuild
  (`docker-compose build --no-cache`).

## Definition of done (2026-07-13 baseline)

This repo is mid-debug — treat the committed error logs as the starting
point, not noise to ignore:

1. Read `build_err.txt`, `dev_err.txt`, and `start_err.txt` FIRST — they are
   the last known failures. Fix those specific errors before doing anything
   else; don't assume a clean slate.
2. `npm run build` completes with no errors, then delete the stale
   `*_err.txt` / `*_utf8.txt` log files once superseded (keep them only if
   still reproducing the same failure).
3. `docker-compose up -d` boots cleanly; `curl http://localhost:3000/health`
   returns `"status": "healthy"` with the expected tool count.
4. Decide and finish the Gemini experiment: `test-gemini.ts`,
   `test_gemini_raw.js`, `test_gemini_v1.js`, `list_models.js`, `list_raw.js`,
   `check_methods.js`, and `models_list.json` look like scratch work for
   adding a Gemini-backed tool. Either wire it into `src/tools/` for real and
   delete the scratch scripts, or delete the scratch scripts if it was
   abandoned — don't leave it half-done and unlabeled.
5. Confirm `MCP_TOKEN` auth actually rejects unauthenticated requests to
   `/tools/*` (a self-hosted tool server with 107 tools, including
   `bash_execute`, is dangerous if the auth check regressed).

