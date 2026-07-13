---
title: Agentic Bridge Control Center (chatnotionreplit)
type: project
status: active
repo: https://github.com/rmaviswholesale-create/chatnotionreplit
tags: [notion, chatgpt, google-workspace, slack, quickbooks, business-ops, replit]
---

# Agentic Bridge Control Center — the business-operations brain

**Repo:** `rmaviswholesale-create/chatnotionreplit` (private, Replit-hosted).
This is the project that runs real business operations — treat changes with
production care. [Source: repo replit.md]

## What it is

Full-stack middleware that connects **ChatGPT Custom GPTs** to **Notion,
Gmail, Google Calendar, Google Drive, Slack, Tally forms, and QuickBooks**
through one authenticated REST API, plus a dashboard UI for monitoring and
testing. A GPT-4o-powered agent with 28+ tools (LangChain ReAct-style
multi-step reasoning, up to 5 tool iterations, Postgres-backed conversation
history) automates email triage, CRM, invoicing, scheduling, and file
organization.

It carries pre-built Notion "operational hubs" for the owner's moving/wholesale
business — Jobs, Crew, Equipment, Service Types, Quotes, Invoices, Schedule
Board — a 22+ procedure SOP database, and additional personal case-tracking
databases (details stay in the private repo, not in this public page).

## Stack

- **Backend:** Express + TypeScript, API-key auth (`NOTION_BRIDGE_API_KEY`,
  Bearer or `X-API-Key`), Drizzle ORM on Neon Postgres, Replit managed OAuth
  for Notion, esbuild for server bundle
- **Frontend:** React + Vite, shadcn/ui (New York) on Radix, Tailwind v4,
  TanStack Query, React Hook Form + Zod; dark glassmorphic theme
- **Layout:** `client/` (UI), `server/` (API + agent + integrations),
  `shared/` (types/schema), OpenAPI 3.1 schema for the Custom GPT

## Key routes

`/api/slack/*` (send, channels, user, history, events webhook),
`/api/google/gmail/send`, `/api/google/calendar/events|event`,
`/api/google/drive/files`, plus the full Notion database/page/block API and
automation jobs (Sheets→Notion sync, email→Notion job entries,
Notion jobs→Calendar sync).

## Repo lineage (don't mix these up)

| Repo | Role |
|---|---|
| `chatnotionreplit` | **Current, active** version — work here |
| `Chatnotion` | Earlier Replit iteration (client/server/shared, replit.md) — superseded |
| `chatnotionserver` | Stub, README-only ("new project") |
| `AgenticNotionBridge` | Empty repo, never pushed |

## Gotchas for agents

- It depends on **Replit platform services** (Connectors OAuth, identity
  tokens) — code that works on Replit may not run locally without stubbing
  those out.
- User data storage is split: Drizzle/Postgres is wired, but some user state
  still uses in-memory `MemStorage` — check before assuming persistence.
- Changes to tool schemas must be mirrored in the OpenAPI 3.1 schema or the
  Custom GPT silently loses the tool.
- This system touches real email, invoices, and business records. Prefer
  dry-runs and test databases; confirm before bulk writes.

## Definition of done (2026-07-13 baseline)

This one is mostly built — "complete and working" here means **verified**,
not built from scratch:

1. Every integration actually authenticates: Notion (OAuth token refresh),
   Gmail send, Calendar create/list, Drive list, Slack send + events webhook,
   QuickBooks customer/invoice calls. Hit each route once for real and
   confirm a non-error response, not just that the server started.
2. Resolve the storage split: find every remaining use of the in-memory
   `MemStorage` and migrate it to the Drizzle/Postgres schema so user data
   survives a restart. List what's still in-memory before declaring this done.
3. The OpenAPI 3.1 schema served to the Custom GPT matches the live tool set
   exactly — no drift between what's documented and what the 28+-tool agent
   can actually call.
4. Automations (Sheets→Notion sync, email→Notion job entries, Notion
   jobs→Calendar sync) each run once successfully against real or sandboxed
   data, not just unit-tested in isolation.
5. Confirm which repo is authoritative going forward — `chatnotionreplit` is
   current; `Chatnotion` should be explicitly archived or deleted once this
   is confirmed, not left ambiguous.

