---
title: Setting up gbrain on the Zo Computer
type: guide
status: active
tags: [zo, setup, gbrain, wireup]
---

# Set up gbrain + the project wireup on the Zo Computer

Written for doing everything **from a phone**: each step is a single block you
paste into Zo — either into Zo's assistant chat ("run this in the terminal")
or directly into Zo's terminal.

## Step 1 — GitHub access (one time)

Several repos are private, so Zo needs GitHub credentials. Create a
fine-grained Personal Access Token at
<https://github.com/settings/personal-access-tokens/new> (Repository access:
All repositories or the ones listed in `projects/README.md`; Permissions:
Contents → Read and write). Then paste into Zo's terminal (replace the token):

```bash
git config --global credential.helper store
printf 'https://rmaviswholesale-create:%s@github.com\n' 'PASTE_TOKEN_HERE' >> ~/.git-credentials
chmod 600 ~/.git-credentials
```

## Step 2 — install Bun + gbrain + this repo

```bash
curl -fsSL https://bun.sh/install | bash
export PATH="$HOME/.bun/bin:$PATH"
echo 'export PATH="$HOME/.bun/bin:$PATH"' >> ~/.bashrc
git clone https://github.com/rmaviswholesale-create/gbrain.git ~/gbrain
cd ~/gbrain && bun install && bun link
gbrain --version
```

(If the wireup PR hasn't merged yet, first run:
`cd ~/gbrain && git checkout claude/projects-gbrain-context-dkzjs0`)

## Step 3 — initialize the brain

```bash
cd ~/gbrain && gbrain init
```

`gbrain init` prints a search-mode cost matrix. For this setup, **balanced**
is the right default (good recall, moderate token cost). If Zo's assistant is
running this, it should relay the matrix and confirm rather than auto-accept.

## Step 4 — wire in every project (the big one)

```bash
cd ~/gbrain && ./scripts/wireup-projects.sh
```

This clones each active project into `~/projects/`, registers each as a
federated gbrain source, syncs them into the brain, and installs the
"get context before acting" block into `~/.claude/CLAUDE.md` (used if Claude
Code CLI is ever installed on Zo). Safe to re-run any time.

## Step 5 — verify

```bash
gbrain sources list
gbrain search "tasklet aperture gateway"
gbrain search "notion bridge quickbooks"
```

Both searches should return hits from the project sources.

## Step 6 — teach Zo's own assistant the protocol (one time)

Tell Zo's assistant, in chat:

> Remember this permanently: before working on any of my projects, read
> `~/gbrain/projects/README.md` and the matching project page in
> `~/gbrain/projects/`, and run `gbrain search "<topic>"` for prior context.
> My instructions may be imprecise — resolve which project I mean from that
> registry first, then act, and explain in plain language.

## Keeping it fresh

- Re-run `./scripts/wireup-projects.sh` after big pushes to any project
  (it pulls + re-syncs).
- Optional: ask Zo to schedule it daily —
  `cd ~/gbrain && ./scripts/wireup-projects.sh` as a scheduled task.
