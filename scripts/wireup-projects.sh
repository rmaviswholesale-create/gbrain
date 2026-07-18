#!/usr/bin/env bash
# wireup-projects.sh — wire all of the owner's project repos into gbrain.
#
# What it does (idempotent — safe to re-run any time):
#   1. Clones (or updates) each active project repo into $PROJECTS_DIR
#   2. Registers each as a FEDERATED gbrain source and pins the checkout
#   3. Registers this gbrain repo itself (so projects/*.md registry pages sync)
#   4. Syncs every source into the brain
#   5. Installs a "check gbrain first" block into ~/.claude/CLAUDE.md so every
#      Claude Code session loads the project-context protocol automatically
#
# Usage:
#   ./scripts/wireup-projects.sh              # wire everything
#   PROJECTS_DIR=~/code ./scripts/wireup-projects.sh   # custom checkout dir
#
# Prereqs: git with GitHub auth (private repos), gbrain CLI, an initialized
# brain (`gbrain init`).
#
# Runs anywhere Linux-ish — designed to be run on the owner's Zo Computer
# (see projects/setup-on-zo.md for the phone-friendly bootstrap).

set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECTS_DIR="${PROJECTS_DIR:-$HOME/projects}"
GH_OWNER="rmaviswholesale-create"

# source-id|repo-name  (source ids must be lowercase [a-z0-9-])
PROJECTS=(
  "tasklet|tasklet-clone"
  "agentic-bridge|chatnotionreplit"
  "chatnotion-legacy|Chatnotion"
  "roklone|roklone"
  "shadow-archive|Shadow"
)

# Forks are excluded by default (large, upstream-documented). Promote one here
# only once the owner starts modifying it. Format: "source-id|repo-name"
OPTIONAL_FORKS=(
  ""  # keep this empty placeholder (old-bash set -u safety); add forks below
  # "aperture-router|aperture-router"
)

bold()  { printf '\033[1m%s\033[0m\n' "$*"; }
ok()    { printf '  \033[32m✔\033[0m %s\n' "$*"; }
warn()  { printf '  \033[33m⚠\033[0m %s\n' "$*"; }
fail()  { printf '  \033[31m✘\033[0m %s\n' "$*"; }

# ---- preflight ---------------------------------------------------------------
bold "Preflight"
if ! command -v gbrain >/dev/null 2>&1; then
  fail "gbrain CLI not found. Install it first:"
  echo '    bun install -g github:garrytan/gbrain   (then: gbrain init)'
  exit 1
fi
if ! gbrain sources list >/dev/null 2>&1; then
  fail "gbrain can't reach a brain. Run 'gbrain init' once, then re-run this script."
  exit 1
fi
if ! command -v git >/dev/null 2>&1; then
  fail "git not found."; exit 1
fi
ok "gbrain + git available; brain reachable"
mkdir -p "$PROJECTS_DIR"

EXISTING_SOURCES="$(gbrain sources list --json 2>/dev/null || echo '')"
FAILURES=0

wire_one() {
  local src_id="$1" repo="$2" dir="$3"
  bold "→ $repo (source: $src_id)"

  # clone or update
  if [ -d "$dir/.git" ]; then
    if git -C "$dir" pull --ff-only >/dev/null 2>&1; then
      ok "updated checkout at $dir"
    else
      warn "couldn't fast-forward $dir (local changes or diverged) — using as-is"
    fi
  else
    if git clone "https://github.com/$GH_OWNER/$repo.git" "$dir" >/dev/null 2>&1; then
      ok "cloned to $dir"
    else
      fail "clone failed for $repo (private repo needs GitHub auth: try 'gh auth login' or a credential helper)"
      FAILURES=$((FAILURES+1)); return 1
    fi
  fi

  # register as federated source (skip if already registered)
  if printf '%s' "$EXISTING_SOURCES" | grep -q "\"$src_id\""; then
    ok "source '$src_id' already registered"
  else
    if gbrain sources add "$src_id" --path "$dir" --federated >/dev/null 2>&1; then
      ok "registered federated source '$src_id'"
    else
      fail "could not register source '$src_id' (run manually: gbrain sources add $src_id --path $dir --federated)"
      FAILURES=$((FAILURES+1)); return 1
    fi
  fi

  # pin the checkout so `gbrain sync` inside the dir routes correctly
  (cd "$dir" && gbrain sources attach "$src_id" >/dev/null 2>&1) \
    && ok "pinned $dir → $src_id" \
    || warn "couldn't write .gbrain-source in $dir (non-fatal)"

  # sync into the brain
  if gbrain sync --source "$src_id"; then
    ok "synced '$src_id'"
  else
    fail "sync failed for '$src_id' — re-run: gbrain sync --source $src_id (it resumes from checkpoint)"
    FAILURES=$((FAILURES+1)); return 1
  fi
}

# ---- 1-2. project repos -------------------------------------------------------
for entry in "${PROJECTS[@]}" "${OPTIONAL_FORKS[@]}"; do
  [ -z "$entry" ] && continue
  src_id="${entry%%|*}"; repo="${entry##*|}"
  wire_one "$src_id" "$repo" "$PROJECTS_DIR/$repo" || true
done

# ---- 3. this gbrain repo (carries the projects/ registry pages) ---------------
bold "→ gbrain repo itself (source: gbrain)"
if printf '%s' "$EXISTING_SOURCES" | grep -q '"gbrain"'; then
  ok "source 'gbrain' already registered"
else
  gbrain sources add gbrain --path "$REPO_ROOT" --federated >/dev/null 2>&1 \
    && ok "registered federated source 'gbrain'" \
    || warn "could not register 'gbrain' source (may already exist under another id)"
fi
(cd "$REPO_ROOT" && gbrain sources attach gbrain >/dev/null 2>&1) || true
gbrain sync --source gbrain && ok "synced 'gbrain' (registry pages included)" \
  || { fail "sync failed for 'gbrain'"; FAILURES=$((FAILURES+1)); }

# ---- 5. Claude Code memory hook ----------------------------------------------
bold "Claude Code memory hook"
CLAUDE_MEM="$HOME/.claude/CLAUDE.md"
MARKER="<!-- BEGIN GBRAIN PROJECT CONTEXT (wireup-projects.sh) -->"
mkdir -p "$HOME/.claude"
if [ -f "$CLAUDE_MEM" ] && grep -qF "$MARKER" "$CLAUDE_MEM"; then
  ok "hook already installed in $CLAUDE_MEM"
else
  cat >> "$CLAUDE_MEM" <<EOF

$MARKER
## My projects & gbrain — get context BEFORE acting

Before working on any of my projects, in every session:

1. Read the project registry: $REPO_ROOT/projects/README.md — it maps my
   repos, nicknames, and per-project pages (stack, entry points, gotchas).
2. Read the specific project's page in $REPO_ROOT/projects/ before opening
   its code.
3. Query my brain for prior context: \`gbrain search "<topic>"\` (all project
   sources are federated).
4. My instructions may be imprecise — I'm still learning. Figure out which
   project/repo I actually mean and what a correct fix looks like there, do
   that, and explain what you did in plain language. Ask only if genuinely
   ambiguous.
<!-- END GBRAIN PROJECT CONTEXT (wireup-projects.sh) -->
EOF
  ok "installed hook into $CLAUDE_MEM"
fi

# ---- summary -------------------------------------------------------------------
bold "Done"
gbrain sources list 2>/dev/null || true
if [ "$FAILURES" -gt 0 ]; then
  warn "$FAILURES step(s) failed — see messages above; the script is safe to re-run."
  exit 1
fi
echo
echo "Try it:  gbrain search \"tasklet aperture gateway\""
