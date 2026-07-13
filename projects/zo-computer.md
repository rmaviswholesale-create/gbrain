---
title: Zo Computer (primary compute)
type: environment
status: active
tags: [zo, compute, environment, hosting]
---

# Zo Computer — the owner's primary machine (as of 2026-07)

Not a repo — the machine itself. The owner's compute situation, so agents stop
assuming a local laptop exists:

- **Phone** — where the owner talks to Claude Code (remote/cloud sessions).
  Nothing can be installed "on the phone"; remote sessions run in ephemeral
  Anthropic containers, not on any owner machine.
- **Zo Computer** ([zo.computer](https://zo.computer)) — a persistent,
  always-on personal Linux server with its own built-in AI assistant,
  terminal, file storage, and hosting. **This is where gbrain and any
  long-running services should live.** Setup: [setup-on-zo.md](setup-on-zo.md).
- **Shadow Tech cloud PC** — former Windows machine; subscription on hold,
  currently inaccessible. Its files are archived in the `Shadow` repo
  ([shadow-ricoos.md](shadow-ricoos.md)).

## Implications for agents

- "Run this locally" means **run it on the Zo Computer** (via its terminal or
  by instructing Zo's assistant), not on a laptop.
- The brain (gbrain database, project checkouts, cron/background jobs) lives
  on Zo at `~/gbrain` + `~/projects` once `setup-on-zo.md` has been followed.
- `roklone` is literally a clone of Zo Computer's concept — the owner now has
  the real thing; roklone remains a learning/self-hosting project.
- Anything that must survive a session (files, databases, tokens) goes on Zo
  or into a git repo — never only in a Claude Code remote container.
