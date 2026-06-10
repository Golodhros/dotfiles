# Marcos's Dotfiles

My personal dotfiles for setting up a Mac development machine.

Feel free to explore, learn, and copy parts for your own dotfiles.

## Quick Start (new personal Mac)

```sh
git clone git@github.com:Golodhros/dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

`install.sh` is idempotent and backs up anything it replaces to `<file>.bak`. It:

1. Checks for Xcode Command Line Tools.
2. Installs **Homebrew** if missing, then runs `brew bundle` (see `Brewfile`).
3. Installs **Oh My Zsh**, **NVM**, **Bashmarks**, and **Powerline Shell** if missing.
4. Symlinks the tracked dotfiles into `~` (`.zshenv`, `.zshrc`, `.zprofile`,
   `git/gitconfig` → `~/.gitconfig`, Powerline config, Cursor settings).
5. Creates `~/.gitconfig.local` from the example (your git identity).
6. Optionally applies macOS defaults (`osx/set-defaults.sh`).

After it finishes, open a new terminal. **Work (Puzzle) setup is intentionally not part
of this** — see "Work vs Personal" below.

## How It Works (loading chain)

Shell is **zsh + Oh My Zsh**. Config loads in this order:

1. **`~/.zshenv`** (→ repo `.zshenv`) — exports `DOTFILES` and `MACOSX_LIBRARY`.
2. **`~/.zprofile`** (→ repo `.zprofile`) — Homebrew `shellenv` (login shells).
3. **`~/.zshrc`** (→ repo `.zshrc`) — sets `ZSH_CUSTOM="$HOME/.dotfiles/zsh"` and sources
   Oh My Zsh.
4. **Oh My Zsh** sources every `*.zsh` in `zsh/` (its default behavior — **no patching of
   `oh-my-zsh.sh` required**):
   - `zsh/aliases.zsh` — file/find/finder/misc aliases, `afk`, `gimmeServer`, `showa`…
   - `zsh/profile.zsh` — sources `git/.config`, `git/.aliases`, `git/.completion`, then `~/.extra`.
   - `zsh/prompt.zsh` — Powerline Shell prompt.
   - `zsh/shell.zsh` — NVM (+ auto-`.nvmrc` switching), `EDITOR=cursor -w`, Bashmarks,
     terminal-title hook.
5. **`~/.extra`** — machine-specific / work config, sourced last (see below). Not tracked.

> Files in `zsh/` are named `*.zsh` so Oh My Zsh loads them natively. Don't rename them
> back to dotfiles — that was an old hack that required editing `oh-my-zsh.sh` and broke
> on every `omz update`.

## Work vs Personal

- **This repo is personal-only and safe to keep public.** Git identity is kept out of the
  tracked `git/gitconfig` via `[include] ~/.gitconfig.local` (template:
  `git/gitconfig.local.example`).
- **Puzzle (work) config lives only in `~/.extra`**, which is git-ignored and sourced
  conditionally from `zsh/profile.zsh` (`[ -f ~/.extra ] && source ~/.extra`). It holds
  work env vars, secrets, gcloud, Cloud SQL proxy aliases, devenv aliases, etc.
- On a **work machine**, restore `~/.extra` yourself (secrets via 1Password). A personal
  machine simply never has the file, so none of the work config loads.

## Repository Layout

| Path | Purpose |
|------|---------|
| `install.sh` | One-command personal Mac bootstrap (symlinks + `brew bundle` + tooling) |
| `Brewfile` | Personal Homebrew packages/casks (work packages in a commented section) |
| `.zshenv` / `.zshrc` / `.zprofile` | Tracked home shell files, symlinked by `install.sh` |
| `zsh/` | `aliases.zsh`, `prompt.zsh`, `profile.zsh`, `shell.zsh` (loaded by Oh My Zsh) |
| `git/` | `gitconfig` (+ `gitconfig.local.example`), shell aliases/pager/completion |
| `osx/` | `set-defaults.sh` (macOS defaults), `lockscreen.sh` (`afk`) |
| `bin/` | `get_song.sh` (yt-dlp), `save_vscode_extensions.sh` |
| `ai/` | Genericized personal AI dev skills & agents for Claude Code; `ai/link.sh` symlinks them into a project's `.claude/` (see `ai/README.md`) |
| `vscode/` | Editor settings/keybindings/extension lists (used by Cursor too) |
| `powerline-shell/` | Powerline Shell segments config + symlink notes |
| `iterm2/` | iTerm2 plist + history snippet (macOS terminal) |
| `bash/` | bash rc/aliases/prompt/profile — for non-zsh machines (Linux / Git Bash) |
| `hyper/` | Hyper terminal config — for **Windows** machines without iTerm2 |

## Windows machines

Windows setup is **manual** (`install.sh` is macOS/bash only). Use the `hyper/.hyper`
config and the `bash/` files as a reference, and copy what you need by hand.

## Editor

Default editor is **Cursor** (`EDITOR="cursor -w"` and `git core.editor = cursor -w`).
Settings/keybindings under `vscode/` are symlinked into Cursor by `install.sh`. Refresh the
extension list with `bin/save_vscode_extensions.sh`.

## Maintenance

- Refresh Homebrew list: `brew bundle dump --file=~/.dotfiles/Brewfile --force`
- Re-running `install.sh` is safe; it relinks and skips already-installed tools.
- See `ASSESSMENT.md` for the review that produced this structure and the remaining ideas.

## Thanks To

- [GitHub does dotfiles](https://dotfiles.github.io/)
- [Zach Holman](https://github.com/holman/dotfiles)
- [Mathias Bynens](https://github.com/mathiasbynens/dotfiles)
- [Dries Vints](https://driesvints.com/blog/getting-started-with-dotfiles/)
