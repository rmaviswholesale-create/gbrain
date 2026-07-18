---
title: Forks and reference repos
type: reference
status: reference
tags: [forks, tooling, reference]
---

# Forks & reference repos

The owner keeps ~30 forks of tools in or adjacent to the personal AI stack.
None carry meaningful owner-authored changes unless noted — they are pinned
references and occasional experiment beds. When a task names one of these,
first check whether the intent is actually one of the original projects in
[README.md](README.md).

## Load-bearing (part of the running stack)

| Fork | Why it matters |
|---|---|
| `aperture-router` | LLM gateway; **Rico's Tasklet routes all model calls through a self-hosted Aperture instance** — the one fork that is live infrastructure |
| `Zo` | Upstream inspiration for `roklone` (Zo Computer) |
| `rover` | Agent task manager (upstream "RoverBook" work); fork synced 2026-07-13 — watch for owner experiments |
| `claude-mem` | Claude memory tooling — same problem space as gbrain |
| `notion-mcp-server` | Notion MCP server — same space as the Agentic Bridge |

## Agent runtimes & coding tools

`claude-code`, `free-claude-code`, `opencode`, `claw-code`, `opendevin-docker`,
`bytebot`, `browser-use`, `software-agent-sdk`, `claude-agent-desktop`,
`compose-for-agents`, `openfang`, `Gensis`, `cli`, `agent-password`,
`ai-website-cloner-template`, `graphify`, `temporal-hubble`(empty, private).

## Docs, learning & curation

`awesome-claude-code`, `awesome-agent-skills`, `claude-quickstarts`,
`openai-cookbook`, `collection-claude-code-source-code`, `context7`,
`vibe-coding-jam-presentation`, `cal.com`.

## Agent guidance

- Don't sync forks into the brain by default — they are large and their
  upstreams document themselves. The wireup script leaves them out; add one
  to the `OPTIONAL_FORKS` list there only when the owner starts modifying it.
- Before working inside a fork, diff against upstream (`git log
  upstream/main..HEAD`) to see whether the owner has local changes worth
  preserving.
