# Project Registry — read this BEFORE working on any of Rico's projects

This directory is the single source of truth for what the owner of this brain
is building. Every page here syncs into the brain (`projects/` is a
`db_tracked` directory in `gbrain.yml`), so `gbrain search` can answer
questions about any project.

## Agent protocol (mandatory)

The owner is self-taught and still learning — instructions may name the wrong
repo, use a nickname, or describe a goal instead of a task. Before acting:

1. **Resolve which project is meant.** Check the inventory table below and the
   per-project pages. Nicknames: "Tasklet" → `tasklet-clone`, "the bridge" /
   "Notion thing" / "GPT bridge" → `agentic-bridge` (repo `chatnotionreplit`),
   "Zo clone" → `roklone`, "my brain" → `gbrain`.
2. **Read that project's page in this directory** (stack, entry points,
   gotchas, current status) before opening code.
3. **Query the brain for prior context**: `gbrain search "<topic>"` — project
   sources are federated, so hits come back from every wired repo.
4. **Interpret the intent, not the literal wording.** If the literal request
   conflicts with how the project actually works, do what the project needs
   and say what you changed and why, in plain language.
5. **Explain like the owner is new to code.** Plain language summaries, no
   unexplained jargon.

## ⚠️ Needs attention right now (as of 2026-07-18)

Five open, unmerged Claude-Code-generated PRs across three repos are the
actual current state of work — check these before assuming any project's
docs/README reflect reality:

| Repo | Open PR | Why it matters |
|---|---|---|
| `tasklet-clone` | [#1](https://github.com/rmaviswholesale-create/tasklet-clone/pull/1) | Fixes a **red CI gate** (41 lint + 27 typecheck errors on `master` itself) |
| `tasklet-clone` | [#2](https://github.com/rmaviswholesale-create/tasklet-clone/pull/2) | Removes the hardcoded Aperture Gateway dependency; adds DeepSeek/OpenRouter + a shell-injection fix |
| `tasklet-clone` | [#3](https://github.com/rmaviswholesale-create/tasklet-clone/pull/3) | Cleanup pass on top of #1/#2 |
| `roklone` | [#1](https://github.com/rmaviswholesale-create/roklone/pull/1) | Fixes a hardcoded API key + hardcoded UI auth token, adds 43 tests and free-hosting deploy — **not a draft, ready to review** |
| `gbrain` | [#1](https://github.com/rmaviswholesale-create/gbrain/pull/1) | This project registry + the wireup script itself |

Details and a merge order are in each project's own page
(`tasklet.md`, `roklone.md`) under "Definition of done."

## Repo inventory (as of 2026-07-18)

| Repo | What it is | Status | Page |
|---|---|---|---|
| `tasklet-clone` (private) | "Rico's Tasklet" — self-hosted AI agent command center | **Active** (pushed 2026-07-13) | [tasklet.md](tasklet.md) |
| `chatnotionreplit` (private) | "Agentic Bridge Control Center" — ChatGPT ↔ Notion/Google/Slack/QuickBooks middleware | **Active** | [agentic-bridge.md](agentic-bridge.md) |
| `Chatnotion` (private) | Earlier Replit iteration of the Agentic Bridge | Superseded | [agentic-bridge.md](agentic-bridge.md) |
| `chatnotionserver` | Stub ("new project") in the same lineage | Stub | [agentic-bridge.md](agentic-bridge.md) |
| `roklone` (private) | "Zo Computer clone" — self-hosted MCP tool server (~107 tools) | WIP | [roklone.md](roklone.md) |
| `Shadow` (private) | File dump from the "Shadow" PC — RicoOS MCP servers + Desktop backup | Archive | [shadow-ricoos.md](shadow-ricoos.md) |
| `gbrain` (public fork) | This repo — the personal knowledge brain engine | **Active** | [gbrain.md](gbrain.md) |
| ~30 forks | Reference forks of tools in the stack (aperture-router, browser-use, …) | Reference | [forks-and-references.md](forks-and-references.md) |
| *(not a repo)* | Zo Computer — the owner's primary machine; phone is just the remote | **Active** | [zo-computer.md](zo-computer.md), setup: [setup-on-zo.md](setup-on-zo.md) |

**Empty repos** (created but never pushed — candidates to delete or start):
`Tasklet_clone`, `lost-found`, `temporal-hubble`, `docker_container_orchestrator`,
`AgenticNotionBridge`.

## How this stays wired

- `scripts/wireup-projects.sh` (in this repo) clones/updates each active
  project, registers it as a federated gbrain source, and syncs it into the
  brain. Re-run it any time; it is idempotent.
- The same script installs a "check gbrain first" block into
  `~/.claude/CLAUDE.md` so every Claude Code session on the owner's machine
  loads this protocol automatically.
- When a project changes significantly, update its page here and re-run
  `gbrain sync` — stale registry pages misroute future agents.

## The big picture (how the projects relate)

```
Rico's stack
├── gbrain            — memory: everything the agents should remember
├── tasklet-clone     — cockpit: web dashboard that runs agents
│     └── depends on Aperture Gateway (see forks: aperture-router)
├── roklone           — hands: MCP server exposing bash/files/browser tools
├── agentic-bridge    — business: ChatGPT ↔ Notion/Google/Slack/QuickBooks
│     └── runs real business operations (wholesale/moving company)
└── Shadow / RicoOS   — archive of the personal machine + early MCP experiments
```
