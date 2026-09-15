#!/usr/bin/env bash
#
# editors/install.sh — link shared editor config into Cursor and VS Code and
# install their extensions. Called by ../install.sh; safe to run on its own.
#
#   editors/install.sh            # link + install extensions for every editor found
#   editors/install.sh link       # only symlink settings/keybindings/snippets (+ CLI into ~/.local/bin)
#   editors/install.sh extensions # only install extensions
#   editors/install.sh dump       # refresh extensions.<cli>.raw.txt from each editor
#
# Editors: Cursor (cli: cursor) and VS Code (cli: code). Each is skipped if its
# .app bundle is not present. One settings.json/keybindings.json is shared by
# both — each editor ignores keys and commands it doesn't know.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EDITORS=("Cursor:cursor:Cursor" "Code:code:Visual Studio Code")   # "<Application Support dir>:<cli>:<.app name>"

info() { printf "\033[1;34m==>\033[0m %s\n" "$1"; }
warn() { printf "\033[1;33m[!]\033[0m %s\n" "$1"; }
ok()   { printf "\033[1;32m[ok]\033[0m %s\n" "$1"; }

# Symlink SRC -> DEST, backing up an existing real file/dir to DEST.bak.
link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ]; then
    rm "$dest"
  elif [ -e "$dest" ]; then
    warn "Backing up existing $dest -> $dest.bak"
    rm -rf "$dest.bak"
    mv "$dest" "$dest.bak"
  fi
  ln -s "$src" "$dest"
  ok "linked $dest -> $src"
}

# Print extension IDs from a list file, dropping comments and blank lines.
ids() { [ -f "$1" ] && sed -e 's/#.*//' -e 's/[[:space:]]*$//' "$1" | grep -v '^$' || true; }

app_path() { for d in /Applications "$HOME/Applications"; do [ -d "$d/$1.app" ] && { echo "$d/$1.app"; return; }; done; return 1; }

# Resolve the editor CLI: on PATH, else the binary bundled inside the .app.
cli_path() {
  local cli="$1" app="$2"
  command -v "$cli" 2>/dev/null && return
  local bundled="$app/Contents/Resources/app/bin/$cli"
  [ -x "$bundled" ] && { echo "$bundled"; return; }
  return 1
}

link_editor() {
  local dir="$1"
  local user="$HOME/Library/Application Support/$dir/User"
  link "$HERE/settings.json"    "$user/settings.json"
  link "$HERE/keybindings.json" "$user/keybindings.json"
  link "$HERE/snippets"         "$user/snippets"
}

# Put the editor CLI (`code`, `cursor`) on PATH via ~/.local/bin if nothing
# else (e.g. the Homebrew cask) already did. ~/.local/bin is added in .zshrc.
link_cli() {
  local cli="$1" app="$2"
  command -v "$cli" >/dev/null 2>&1 && { ok "$cli: already on PATH ($(command -v "$cli"))"; return; }
  local bundled="$app/Contents/Resources/app/bin/$cli"
  [ -x "$bundled" ] || { warn "$cli: bundled CLI not found at $bundled"; return; }
  link "$bundled" "$HOME/.local/bin/$cli"
}

install_extensions() {
  local cli="$1" bin="$2"
  local installed; installed="$("$bin" --list-extensions 2>/dev/null | tr '[:upper:]' '[:lower:]')"
  { ids "$HERE/extensions.common.txt"; ids "$HERE/extensions.$cli.txt"; } | while read -r ext; do
    if grep -qix "$ext" <<<"$installed"; then
      ok "$cli: $ext already installed"
    else
      info "$cli: installing $ext"
      "$bin" --install-extension "$ext" >/dev/null
    fi
  done
}

dump_extensions() {
  local cli="$1" bin="$2"
  "$bin" --list-extensions | sort > "$HERE/extensions.$cli.raw.txt"
  ok "$cli: wrote extensions.$cli.raw.txt (diff against the curated lists, then delete)"
}

action="${1:-all}"
for entry in "${EDITORS[@]}"; do
  IFS=: read -r dir cli name <<<"$entry"
  app="$(app_path "$name")" || { warn "$name.app not installed; skipping"; continue; }
  info "$name"
  bin=""
  if [ "$action" != "link" ]; then
    bin="$(cli_path "$cli" "$app")" || { warn "'$cli' CLI not found; skipping extensions"; bin=""; }
  fi
  case "$action" in
    all)        link_editor "$dir"; link_cli "$cli" "$app"; [ -n "$bin" ] && install_extensions "$cli" "$bin" ;;
    link)       link_editor "$dir"; link_cli "$cli" "$app" ;;
    extensions) [ -n "$bin" ] && install_extensions "$cli" "$bin" ;;
    dump)       [ -n "$bin" ] && dump_extensions "$cli" "$bin" ;;
    *) echo "Usage: $0 [all|link|extensions|dump]"; exit 1 ;;
  esac
done
