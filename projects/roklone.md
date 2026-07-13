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
