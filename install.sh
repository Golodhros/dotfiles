#!/usr/bin/env bash
#
# install.sh — set up a personal macOS dev machine from this repo.
#
#   git clone git@github.com:Golodhros/dotfiles.git ~/.dotfiles
#   ~/.dotfiles/install.sh
#
# Idempotent: safe to re-run. Anything it replaces is backed up to <file>.bak.
# Puzzle (work) config lives in ~/.extra and is restored separately — see README.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES

info()  { printf "\033[1;34m==>\033[0m %s\n" "$1"; }
warn()  { printf "\033[1;33m[!]\033[0m %s\n" "$1"; }
ok()    { printf "\033[1;32m[ok]\033[0m %s\n" "$1"; }

# Symlink SRC -> DEST, backing up an existing real file/dir to DEST.bak.
link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ]; then
    rm "$dest"
  elif [ -e "$dest" ]; then
    warn "Backing up existing $dest -> $dest.bak"
    mv "$dest" "$dest.bak"
  fi
  ln -s "$src" "$dest"
  ok "linked $dest -> $src"
}

# --- 1. Xcode Command Line Tools ---------------------------------------------
if ! xcode-select -p >/dev/null 2>&1; then
  info "Installing Xcode Command Line Tools (follow the GUI prompt, then re-run)..."
  xcode-select --install || true
  exit 1
fi

# --- 2. Homebrew -------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"; fi
fi

# --- 3. Homebrew bundle ------------------------------------------------------
if [ -f "$DOTFILES/Brewfile" ]; then
  info "Installing Homebrew packages (brew bundle)..."
  brew bundle --file="$DOTFILES/Brewfile"
fi

# --- 4. Oh My Zsh ------------------------------------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Installing Oh My Zsh..."
  RUNZSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# --- 5. NVM ------------------------------------------------------------------
if [ ! -d "$HOME/.nvm" ]; then
  info "Installing NVM..."
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# --- 6. Bashmarks ------------------------------------------------------------
if [ ! -f "$HOME/.local/bin/bashmarks.sh" ]; then
  info "Installing Bashmarks..."
  tmp="$(mktemp -d)"
  git clone --depth 1 https://github.com/huyng/bashmarks.git "$tmp"
  ( cd "$tmp" && make install )
  rm -rf "$tmp"
fi

# --- 7. Powerline Shell ------------------------------------------------------
if ! command -v powerline-shell >/dev/null 2>&1; then
  info "Installing Powerline Shell (via pipx)..."
  command -v pipx >/dev/null 2>&1 || brew install pipx
  pipx install powerline-shell
fi

# --- 8. Symlink dotfiles -----------------------------------------------------
info "Linking dotfiles..."
link "$DOTFILES/.zshenv"          "$HOME/.zshenv"
link "$DOTFILES/.zshrc"           "$HOME/.zshrc"
link "$DOTFILES/.zprofile"        "$HOME/.zprofile"
link "$DOTFILES/git/gitconfig"    "$HOME/.gitconfig"
link "$DOTFILES/powerline-shell/config.json" "$HOME/.config/powerline-shell/config.json"

# Editor (Cursor) settings, if Cursor is installed.
CURSOR_USER="$HOME/Library/Application Support/Cursor/User"
if [ -d "$HOME/Library/Application Support/Cursor" ]; then
  link "$DOTFILES/vscode/settings.json"    "$CURSOR_USER/settings.json"
  link "$DOTFILES/vscode/keybindings.json" "$CURSOR_USER/keybindings.json"
fi

# --- 9. Git identity (untracked, per-machine) --------------------------------
if [ ! -f "$HOME/.gitconfig.local" ]; then
  info "Creating ~/.gitconfig.local from example (edit name/email if needed)..."
  cp "$DOTFILES/git/gitconfig.local.example" "$HOME/.gitconfig.local"
fi

# --- 10. macOS defaults (optional) -------------------------------------------
read -r -p "Apply macOS defaults (osx/set-defaults.sh)? [y/N] " reply
if [[ "$reply" =~ ^[Yy]$ ]]; then
  sh "$DOTFILES/osx/set-defaults.sh"
fi

# --- Done --------------------------------------------------------------------
ok "Personal setup complete. Open a new terminal."
warn "Puzzle (work) config is NOT installed by this script."
warn "On a work machine, restore ~/.extra (secrets via 1Password) — see README.md."
