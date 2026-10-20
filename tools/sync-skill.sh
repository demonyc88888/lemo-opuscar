#!/bin/sh
# sync-skill.sh — regenerate the platform skill copies from the single source of truth.
#
# Source of truth:  plugin/skills/lemo-opuscar/          (Claude Code plugin layout, upstream)
# Generated copies:
#   .agents/skills/lemo-opuscar/                        (Codex: repo-level skill discovery)
#   + agents/openai.yaml sidecar from adapters/codex/openai.yaml (Codex UI metadata)
#   packages/workbuddy/lemo-opuscar/                     (WorkBuddy: folder form; zip it or
#                                                        the root form — see adapters/WORKBUDDY.md)
#
# The copies are generated, never hand-edited: edit the source (or the sidecar
# template), then re-run this script. Idempotent; safe to run after every
# upstream sync. POSIX sh, no dependencies beyond cp/mkdir.
set -e
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SRC="$ROOT/plugin/skills/lemo-opuscar"

sync_codex() {
  dst="$ROOT/.agents/skills/lemo-opuscar"
  rm -rf "$dst"
  mkdir -p "$dst"
  cp -R "$SRC/." "$dst/"
  if [ -f "$ROOT/adapters/codex/openai.yaml" ]; then
    mkdir -p "$dst/agents"
    cp "$ROOT/adapters/codex/openai.yaml" "$dst/agents/openai.yaml"
  fi
  echo "codex:  $dst"
}

sync_workbuddy() {
  dst="$ROOT/packages/workbuddy/lemo-opuscar"
  rm -rf "$dst"
  mkdir -p "$dst"
  cp -R "$SRC/." "$dst/"
  echo "workbuddy: $dst"
}

sync_codex
sync_workbuddy
echo "done. Commit the regenerated copies together with the source change."
