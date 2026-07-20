#!/usr/bin/env bash
# Install the agents-workflow skill for a given AI coding agent.
#
# Usage:
#   ./install.sh --agent claude   [--global | --project DIR]
#   ./install.sh --agent cursor   [--project DIR]
#   ./install.sh --agent opencode [--global | --project DIR]
#   ./install.sh --agent generic  [--project DIR]     # AGENTS.md standard
#
# Defaults: --project . (current directory). --global uses your home config.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BODY="$HERE/skill/agents-workflow.md"
[ -f "$BODY" ] || { echo "ERROR: $BODY not found (run from the repo)."; exit 1; }

DESC="Bootstrap and maintain the .agents/ Markdown project-memory workflow (executor/auditor roles, files as durable state). Use when starting a new project with this system, when asked to set up .agents/, or to plan / audit / compact project state."

AGENT=""; SCOPE="project"; DIR="."
while [ $# -gt 0 ]; do
  case "$1" in
    --agent) AGENT="$2"; shift 2;;
    --global) SCOPE="global"; shift;;
    --project) SCOPE="project"; DIR="${2:-.}"; shift 2;;
    -h|--help) sed -n '2,12p' "$0"; exit 0;;
    *) echo "Unknown arg: $1"; exit 1;;
  esac
done
[ -n "$AGENT" ] || { echo "ERROR: --agent required (claude|cursor|opencode|generic)"; exit 1; }

# Idempotently place the skill inside an AGENTS.md between markers:
# replace an existing marked block, else append; create the file if missing.
write_marked() {
  local target="$1" begin="<!-- BEGIN agents-workflow -->" end="<!-- END agents-workflow -->"
  mkdir -p "$(dirname "$target")"
  local block; block="$(mktemp)"
  { echo "$begin"; cat "$BODY"; echo "$end"; } > "$block"
  if [ -f "$target" ] && grep -qF "$begin" "$target"; then
    # strip the old marked block (markers included), then re-append the fresh one
    awk -v b="$begin" -v e="$end" '
      $0==b {drop=1} !drop {print} $0==e {drop=0}' "$target" > "$target.tmp"
    { printf '\n'; cat "$block"; } >> "$target.tmp"
    mv "$target.tmp" "$target"
  elif [ -f "$target" ]; then
    { echo ""; cat "$block"; } >> "$target"
  else
    cat "$block" > "$target"
  fi
  rm -f "$block"
}

case "$AGENT" in
  claude)
    if [ "$SCOPE" = global ]; then base="$HOME/.claude"; else base="$DIR/.claude"; fi
    out="$base/skills/agents-workflow/SKILL.md"; mkdir -p "$(dirname "$out")"
    { printf -- "---\nname: agents-workflow\ndescription: %s\n---\n\n" "$DESC"; cat "$BODY"; } > "$out"
    echo "Installed → $out";;
  cursor)
    out="$DIR/.cursor/rules/agents-workflow.mdc"; mkdir -p "$(dirname "$out")"
    { printf -- "---\ndescription: %s\nglobs:\nalwaysApply: false\n---\n\n" "$DESC"; cat "$BODY"; } > "$out"
    echo "Installed → $out  (set alwaysApply: true to always load)";;
  opencode)
    if [ "$SCOPE" = global ]; then out="$HOME/.config/opencode/AGENTS.md"; else out="$DIR/AGENTS.md"; fi
    write_marked "$out"; echo "Installed → $out  (OpenCode reads AGENTS.md)";;
  generic)
    out="$DIR/AGENTS.md"; write_marked "$out"
    echo "Installed → $out  (AGENTS.md standard — read by many tools)";;
  *) echo "ERROR: unknown agent '$AGENT'"; exit 1;;
esac

echo "Done. In your agent, ask it to 'set up the .agents/ structure' to bootstrap a project."
