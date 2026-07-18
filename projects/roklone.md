---
title: roklone (Zo Computer clone)
type: project
status: active
repo: https://github.com/rmaviswholesale-create/roklone
tags: [mcp, tools, docker, playwright, self-hosted]
---

# roklone — self-hosted "Zo Computer" clone (MCP tool server)

**Repo:** `rmaviswholesale-create/roklone` (private). [Source: repo SETUP.md +
open PR, checked 2026-07-18]

## What it is

A self-hosted agentic environment modeled on Zo Computer (see the `Zo` fork):
a Node/TypeScript server exposing tools — bash execution, filesystem,
memory (fact storage), Playwright browser automation, and integrations
(GitHub, Slack, Notion, OpenAI, Anthropic) — over two surfaces:

1. **HTTP API** on port 3000 (`/health`, `/tools`, `POST /tools/<name>`),
   Bearer-token auth via `MCP_TOKEN`
2. **MCP stdio server** (`dist/index.js`) for Claude Desktop / Cursor

## ⚠️ One open PR fixes exactly what was broken — review and merge it

`main` was left mid-debug (committed `build_err.txt`/`dev_err.txt`/
`start_err.txt`, half-finished Gemini experiment scripts, a hardcoded Gemini
API key, a hardcoded auth token shipped in the UI source). **[PR #1](https://github.com/rmaviswholesale-create/roklone/pull/1)**
— "v2 revamp: provider-routed chat, secure UI, test suite, free hosting" —
fixes essentially all of it and is **not a draft** (ready for real review),
last updated 2026-07-18:

- Removes the hardcoded Gemini key; adds a provider factory so Claude /
  Gemini / GPT / Ollama all work, plus a zero-key `mock-echo` demo provider
- Removes the hardcoded bearer token from the UI source — the frontend now
  shows an unlock overlay and stores the token in localStorage instead
- Adds a conversation history panel, safe markdown rendering, model/persona
  pickers
- **43 vitest + supertest tests**, no API keys or network required
- Multi-stage `Dockerfile` + a `render.yaml` blueprint for one-click free
  hosting (Render), fixes a broken `docker-compose` port mapping, commits
  `package-lock.json` for reproducible builds
- Rewrites the README (was a broken UTF-16 stub)

This is the single highest-leverage action on this repo: merging it turns
"broken, mid-debug, hardcoded secrets" into "tested, documented, deployable
for free."

## Stack & layout

- Node 20+/24+, TypeScript, Express-style HTTP server, Docker-first
- `src/` (tools in `src/tools/`), `web/` (frontend), `skills/` dir
- Read `CLAUDE.md` for real documentation — the README was a stub before PR #1

## Origin note

Originally developed on the Windows "Shadow" PC (now suspended — see
`shadow-ricoos.md`). Current work happens wherever the owner runs Claude Code.

## Gotchas for agents

- Until PR #1 merges, `main` still has the hardcoded Gemini key and bearer
  token — don't treat `main` as safe to deploy as-is.
- Secrets go in `.env` — never commit them (this was the exact bug PR #1
  fixes).
- Bash/file tools give an agent full machine access — keep resource limits
  and token auth intact when editing.

## Definition of done (2026-07-18 baseline)

1. **Review PR #1 line by line, then merge it** — it fixes the hardcoded
   secrets, the broken deploy, and adds the only test coverage this repo has.
2. After merge: run `npm test` (43 tests should pass), then deploy via the
   new `render.yaml` blueprint or Docker and confirm `/health` reports
   healthy with the real tool count.
3. Decide whether the Gemini experiment scripts the old `main` carried
   (`test-gemini.ts`, `list_models.js`, etc.) are superseded by PR #1's
   provider factory — if so, they can be deleted once merged.
4. Confirm `MCP_TOKEN` (or the new UI unlock flow) actually rejects
   unauthenticated requests to `/tools/*` — this server can run bash
   commands, so auth regressions are high-severity.
