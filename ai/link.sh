#!/usr/bin/env bash
#
# link.sh — symlink AI skills/agents from this library into a project's .claude/ dir.
#
# Run from the TARGET project's root (the repo you want to use the skills in):
#
#   ~/.dotfiles/ai/link.sh --list           # show available skills & agents
#   ~/.dotfiles/ai/link.sh --all            # link everything
#   ~/.dotfiles/ai/link.sh code-review quality unit-test   # link skills (+ their agents)
#   ~/.dotfiles/ai/link.sh --agent knip-agent              # link a standalone agent
#
# Symlinks point at this library (absolute), so editing a definition here updates
# every project that links it. Add `.claude/skills/` and `.claude/agents/` to the
# project's .gitignore so your selections stay local.

set -euo pipefail

AI_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$PWD/.claude"

# Skills that dispatch agents need those agents linked too.
agent_deps() {
  case "$1" in
    architecture-review) echo "ar-agent" ;;
    code-review)         echo "cr-agent" ;;
    create-story)        echo "story-agent" ;;
    document)            echo "doc-agent" ;;
    dry-review)          echo "dry-agent" ;;
    quality)             echo "cr-agent ar-agent dry-agent style-agent" ;;
    style-review)        echo "style-agent" ;;
    unit-test)           echo "ut-agent" ;;
    *)                   echo "" ;;  # audit-changes, build, rfc-review, verify-issues: none
  esac
}

link() {  # link <src> <dest>
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ]; then rm "$dest"; elif [ -e "$dest" ]; then
    echo "  skip (real file exists): $dest"; return; fi
  ln -s "$src" "$dest"
  echo "  linked $(basename "$dest")"
}

link_skill() {
  local name="$1"
  [ -d "$AI_DIR/skills/$name" ] || { echo "  no such skill: $name"; return 1; }
  link "$AI_DIR/skills/$name" "$TARGET/skills/$name"
  for a in $(agent_deps "$name"); do link_agent "$a"; done
}

link_agent() {
  local name="${1%.md}"
  [ -f "$AI_DIR/agents/$name.md" ] || { echo "  no such agent: $name"; return 1; }
  link "$AI_DIR/agents/$name.md" "$TARGET/agents/$name.md"
}

list() {
  echo "Skills:"; for d in "$AI_DIR"/skills/*/; do
    n="$(basename "$d")"; printf "  %-20s agents: %s\n" "$n" "$(agent_deps "$n" | sed 's/^$/(none)/')"; done
  echo "Agents:"; for f in "$AI_DIR"/agents/*.md; do echo "  $(basename "$f" .md)"; done
}

[ $# -eq 0 ] && { echo "Usage: link.sh [--list | --all | <skill>... | --agent <name>]"; exit 1; }

case "${1:-}" in
  --list) list; exit 0 ;;
  --all)
    echo "Linking all skills & agents into $TARGET ..."
    for d in "$AI_DIR"/skills/*/; do link_skill "$(basename "$d")"; done
    for f in "$AI_DIR"/agents/*.md; do link_agent "$(basename "$f" .md)"; done ;;
  --agent)
    shift; for a in "$@"; do link_agent "$a"; done ;;
  *)
    echo "Linking selected skills into $TARGET ..."
    for s in "$@"; do link_skill "$s"; done ;;
esac

echo "Done. (Tip: add .claude/skills/ and .claude/agents/ to the project's .gitignore.)"
