# Marcos's Dotfiles

My personal dotfiles for setting up a Mac development machine.

Feel free to explore, learn, and copy parts for your own dotfiles.

> **Status note (2026-06):** This repo is currently a **reference/backup**, not an
> automated installer. Setup is mostly manual (see below) and the live machine has
> drifted from what's committed here. See `ASSESSMENT.md` for the gap analysis and a
> roadmap toward a fast, repeatable bootstrap.

## How It Works (Loading Chain)

On the current machine the shell is **zsh + Oh My Zsh**. Configuration loads in this order:

1. **`~/.zshenv`** — copy of this repo's `.zshenv`. Exports `DOTFILES="$HOME/.dotfiles"`
   and `MACOSX_LIBRARY`. Sourced for every shell invocation (incl. non-interactive).
2. **`~/.zprofile`** — sets up Homebrew (`brew shellenv`). Login shells only. *Not* tracked
   in this repo.
3. **`~/.zshrc`** — the Oh My Zsh-generated rc. *Not* tracked in this repo. Key lines:
   - `ZSH_CUSTOM="$HOME/.dotfiles/zsh"` — points Oh My Zsh's custom dir at this repo.
   - `source $ZSH/oh-my-zsh.sh`
4. **Oh My Zsh custom loader** — `~/.oh-my-zsh/oh-my-zsh.sh` has been **manually patched**
   so its custom-file glob loads dotfiles by name:
   ```zsh
   # patched line (~209): loads .*-prefixed files instead of the default *.zsh
   for config_file ("$ZSH_CUSTOM"/.*); do
     source "$config_file"
   done
   ```
   This sources every dotfile in `zsh/`:
   - **`zsh/.zsh_aliases`** — ls/find/finder/misc aliases, `afk` lock-screen, `gimmeServer`, etc.
   - **`zsh/.zsh_prompt`** — Powerline Shell prompt hook.
   - **`zsh/.zsh_profile`** — sources `git/.config`, `git/.aliases`, `git/.completion`,
     then `~/.extra`.
   - **`zsh/.zshrc`** — NVM, `EDITOR`, Bashmarks, terminal-title hook.
5. **`~/.extra`** — machine-specific + secret config (see below). Sourced last from
   `zsh/.zsh_profile`. **Not tracked in this repo** (and must never be).

> ⚠️ The Oh My Zsh patch in step 4 is fragile: **updating Oh My Zsh reverts it**, which
> silently stops all `zsh/` config from loading. See `ASSESSMENT.md` for a fix.

### `~/.extra` — machine-specific and secret config

`~/.extra` is the seam for everything that should not live in a public repo:

- Per-machine tooling bootstrap (Homebrew, NVM + auto-`nvmrc`, Powerline, Bashmarks,
  Google Cloud SDK).
- **Puzzle (work) configuration and secrets**: `gcloud` paths, secret-manager paths,
  Cloud SQL proxy aliases, devenv/ledger/accounting/gateway/frontend start aliases,
  and API tokens.

**Secrets currently live here in plaintext.** There is no committed template and no
documented restore path, so on a fresh machine these are lost. See `ASSESSMENT.md`
("Secrets") for the recommended fix (1Password-sourced template `extra.example`).

There is a `~/.extra.backup` on the current machine from an earlier version.

## Repository Layout

| Path | Purpose | Status |
|------|---------|--------|
| `.zshenv`, `.dotfiles_env` | Export `DOTFILES`/`MACOSX_LIBRARY` (identical copies) | Active (zsh uses `~/.zshenv`) |
| `zsh/` | zsh rc, aliases, prompt, profile loader | **Active** |
| `git/` | git aliases, pager config, completion scripts | **Active** (sourced) |
| `bin/` | `get_song.sh` (yt-dlp), `save_vscode_extensions.sh` | Helper scripts |
| `osx/` | `set-defaults.sh` (macOS defaults), `lockscreen.sh` (`afk`) | Active |
| `install.sh` | Bootstrap script — **mostly stubbed**, only runs `osx/set-defaults.sh` | Incomplete |
| `vscode/` | settings, keybindings, extension lists, symlink instructions | Reference |
| `iterm2/` | iTerm2 plist + history snippet | Reference |
| `powerline-shell/` | Powerline Shell segments config + symlink instructions | Reference |
| `bash/` | bash rc/aliases/prompt/profile | **Legacy** (machine uses zsh) |
| `hyper/` | Hyper terminal config | **Legacy** (machine uses iTerm2) |
| `sublime/` | Sublime Text user dir incl. bundled themes/binaries + `.DS_Store` | **Legacy/bloat** |

## Fresh Mac Setup (manual, current process)

> This reflects what actually has to happen today. It is manual and error-prone — the
> roadmap in `ASSESSMENT.md` proposes automating it.

1. **Xcode Command Line Tools**: `xcode-select --install` (or install Xcode from the App
   Store and accept the license).
2. **Homebrew**: install from <https://brew.sh>. Confirm `~/.zprofile` has
   `eval "$(/opt/homebrew/bin/brew shellenv)"` (exactly once).
3. **SSH keys**: copy your public/private keys to `~/.ssh` and `chmod 600` the private key.
4. **Clone this repo**: `git clone git@github.com:Golodhros/dotfiles.git ~/.dotfiles`
5. **Tooling** (currently installed by hand; should move into Brewfile/install.sh):
   - [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)
   - [NVM](https://github.com/nvm-sh/nvm)
   - [Bashmarks](https://github.com/huyng/bashmarks) → `~/.local/bin/bashmarks.sh`
   - [Powerline Shell](https://github.com/b-ryan/powerline-shell) + [Powerline fonts](https://github.com/powerline/fonts)
6. **Wire up zsh**:
   - Copy `~/.dotfiles/.zshenv` → `~/.zshenv`.
   - In the Oh My Zsh `~/.zshrc`, set `ZSH_CUSTOM="$HOME/.dotfiles/zsh"`.
   - Patch `~/.oh-my-zsh/oh-my-zsh.sh`: replace
     `for config_file ("$ZSH_CUSTOM"/*.zsh(N)); do` with
     `for config_file ("$ZSH_CUSTOM"/.*); do`.
7. **Create `~/.extra`** with machine + Puzzle config and secrets (restore from your
   password manager — see `ASSESSMENT.md`).
8. **Symlinks** (manual today):
   - Powerline: `ln -s ~/.dotfiles/powerline-shell/config.json ~/.config/powerline-shell/config.json`
   - VSCode: see `vscode/instructions.txt`.
9. **macOS defaults**: `~/.dotfiles/install.sh` (currently this only runs
   `osx/set-defaults.sh`).

## Editor

The machine currently uses **Cursor** (`~/.gitconfig` editor is `cursor -w`) while the
shell `EDITOR` is `code -w` — these are inconsistent (see `ASSESSMENT.md`). VSCode
settings/extensions are tracked under `vscode/`; refresh the extension list with
`bin/save_vscode_extensions.sh`.

## Git

`~/.gitconfig` (identity, editor) is **not tracked** in this repo today. The repo's
`git/` dir only provides aliases, a pager tweak, and completion. See `ASSESSMENT.md`
for the recommended split (tracked base config + untracked identity).

## Thanks To

- [GitHub does dotfiles](https://dotfiles.github.io/)
- [Zach Holman](https://github.com/holman/dotfiles)
- [Mathias Bynens](https://github.com/mathiasbynens/dotfiles)
- [Dries Vints](https://driesvints.com/blog/getting-started-with-dotfiles/)
