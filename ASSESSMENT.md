# Dotfiles Assessment & Improvement Roadmap

_Last reviewed: 2026-06-04 · Updated: 2026-06-05_

Goal driving this assessment: **(1)** stand up a new dev machine quickly and repeatably,
and **(2)** keep a clean separation between Puzzle (work) and personal concerns.

## Update (2026-06-05): what was implemented

On branch `chore/reproducible-personal-setup`:

- ✅ **Removed the Oh My Zsh patch.** `zsh/.zsh_*` renamed to `*.zsh`; restored the default
  `oh-my-zsh.sh` glob. Survives `omz update` now.
- ✅ **Cursor as default editor** (`EDITOR` + `git core.editor`). NVM auto-`.nvmrc`
  switching moved into the repo (idempotent, won't double-run when `~/.extra` also has it).
- ✅ **Tracked the real state:** added `.zshrc`, `.zprofile` (single `brew shellenv`),
  and `git/gitconfig` + `git/gitconfig.local.example` (identity via `[include]`).
- ✅ **Real `install.sh` + `Brewfile`** — one-command idempotent bootstrap with backups.
- ✅ **Work/personal boundary** documented; repo is personal-only, `~/.extra` is the
  opt-in work seam.
- ✅ **Cleanup:** removed `sublime/` (~20 MB), deduped `.dotfiles_env`, added `.gitignore`.
  Kept `bash/` (non-zsh machines) and `hyper/` (Windows) per request.

**Intentionally deferred:** the secrets hardening (issue #1) — `~/.extra` stays a manual,
1Password-restored file. **Not done in this pass:** Windows automation (Mac-only by
choice). Remaining optional ideas are in the roadmap below.

## Executive Summary

The repo works on the current machine but is a **manual reference, not an installer**.
Bootstrapping a new machine today means ~9 hand-done steps including a fragile patch to
Oh My Zsh's own source and hand-recreating `~/.extra` with secrets that exist nowhere but
this laptop. There is meaningful drift (the real `~/.zshrc` and `~/.gitconfig` aren't
tracked), several layers of duplication, and a chunk of dead weight (bash, Hyper,
Sublime). Puzzle and personal config are tangled together inside a single untracked
`~/.extra`.

The good news: the bones are fine. A modest, focused cleanup gets you to a
"clone + one command" bootstrap with a clear work/personal boundary.

---

## What's Good

- **Clear modular split** of concerns into `zsh/`, `git/`, `osx/`, etc.
- **`~/.extra` seam** for machine-specific config is the right idea — secrets and
  work config are kept *out* of the committed repo.
- **NVM auto-`.nvmrc`** switching, useful git aliases, sensible macOS defaults.
- **`DOTFILES` env var** indirection makes paths portable.

---

## Issues (by severity)

### 🔴 High

1. **Plaintext secrets with no restore path.** `~/.extra` holds live credentials
   (GitHub PAT, CircleCI token, Bugsnag tokens, a Lighthouse password). They are not in
   git (good) but they live only on this disk in plaintext. On a new machine they're
   gone, and on this machine any process/backup can read them.
   - **Rotate** the GitHub PAT and any token that has ever been pasted/shared — treat
     them as potentially exposed.
   - Move secrets to **1Password** (already referenced in `~/.extra` comments) and load
     them via `op read`/`op run`, or at minimum source a git-ignored `~/.extra.secrets`
     that's documented and restorable.

2. **Fragile Oh My Zsh source patch.** Setup requires editing
   `~/.oh-my-zsh/oh-my-zsh.sh` (the `for config_file ("$ZSH_CUSTOM"/.*)` line). Any
   `omz update` reverts it, silently disabling all `zsh/` config. This is also the
   single most confusing part of a fresh setup.
   - **Fix:** rename the `zsh/` files to the convention Oh My Zsh already loads
     (`*.zsh`, e.g. `aliases.zsh`, `prompt.zsh`, `profile.zsh`) and delete the patch
     entirely. No more editing OMZ internals.

### 🟠 Medium

3. **Repo is not an installer; real config has drifted.** `install.sh` is almost
   entirely commented out (only runs `osx/set-defaults.sh`). The actually-loaded
   `~/.zshrc` and `~/.zprofile` and `~/.gitconfig` are **not tracked**, so the repo
   doesn't capture the real state. New-machine setup is 100% manual.
   - **Fix:** add a real `install.sh` (or [`stow`](https://www.gnu.org/software/stow/) /
     [Dotbot](https://github.com/anishathalye/dotbot)) that symlinks tracked files and a
     `Brewfile` (`brew bundle`) that installs tooling.

4. **Work/personal not actually separated.** Everything — personal tooling *and* Puzzle
   secrets/aliases — is jammed into one untracked `~/.extra`. There's no boundary.
   - **Fix:** split into layered, explicit files (see "Proposed Architecture").

5. **Duplication across files.** Same logic defined in multiple places:
   - Powerline prompt hook: `zsh/.zsh_prompt` **and** `~/.extra`.
   - NVM load: `zsh/.zshrc`, `~/.extra`, **and** `bash/.bashrc`.
   - Bashmarks: `zsh/.zshrc` **and** `~/.extra`.
   - Homebrew `shellenv`: `~/.zprofile` (×5!) **and** `~/.extra`.
   - `~/.zprofile` literally repeats `eval "$(brew shellenv)"` five times.
   - `zsh/.zsh_aliases` defines `alias path=...` twice and `~/.extra` has the
     `unsetopt inc_append_history`/`share_history` block twice.
   - **Fix:** single source of truth per concern; delete the copies.

6. **Editor inconsistency.** `~/.gitconfig` uses `cursor -w`; shell `EDITOR` is
   `code -w`. Pick one (likely Cursor) and set it once.

### 🟡 Low / hygiene

7. **Dead weight inflating the repo and setup:**
   - `bash/` — machine uses zsh.
   - `hyper/` — machine uses iTerm2.
   - `sublime/` — large, includes bundled binaries (`ColorPicker_*`), theme packs, an
     `.SublimeREPLHistory/`, and a committed `.DS_Store`. Almost certainly unused now.
   - **Fix:** delete or move to an `archive/` branch/dir.
8. **`.zshenv` and `.dotfiles_env` are byte-identical** — keep one.
9. **No `.gitignore`** (e.g. for `.DS_Store`, `*.backup`, `extra.secrets`).
10. **README was stale** — now rewritten to match reality; this file holds the roadmap.
11. **Hardcoded absolute paths** (`/Users/miglesias/...`) in `vscode/instructions.txt`
    and `~/.extra` reduce portability across machines/usernames.

---

## Proposed Architecture (work / personal separation)

Layer config so each file has one owner and the work/personal boundary is explicit:

```
~/.zshenv                 → exports DOTFILES (tracked)
~/.zshrc / ~/.zprofile    → tracked in repo, symlinked (capture the real state)
zsh/aliases.zsh           → personal aliases (renamed, no OMZ patch)
zsh/prompt.zsh            → prompt (single definition)
zsh/profile.zsh           → loads git/*, then ~/.config/dotfiles/personal.sh, then work.sh
git/base.gitconfig        → tracked aliases/pager (no identity)
~/.gitconfig.local        → identity + editor (untracked, per-machine)

~/.config/dotfiles/personal.sh   → personal tooling (nvm, bashmarks, powerline)  [untracked or tracked-no-secrets]
~/.config/dotfiles/work.sh       → Puzzle aliases + non-secret config            [untracked]
~/.config/dotfiles/work.secrets  → Puzzle secrets, sourced from 1Password        [untracked, never committed]
extra.example                    → committed template documenting every var above
```

Conditional work loading (so a personal machine never tries to load Puzzle config):

```zsh
# in profile.zsh
[ -f ~/.config/dotfiles/personal.sh ] && source ~/.config/dotfiles/personal.sh
if [ -f ~/.config/dotfiles/work.sh ]; then          # only present on the work laptop
  source ~/.config/dotfiles/work.sh
  source ~/.config/dotfiles/work.secrets
fi
```

This way the **public repo stays personal-only**, work config is opt-in per machine, and
secrets are sourced from a vault with a committed template (`extra.example`) so a new
machine is reproducible.

---

## Roadmap (suggested order)

1. **Security first:** rotate exposed tokens; move secrets to 1Password; add
   `extra.example`. _(High value, low effort.)_
2. **Kill the OMZ patch:** rename `zsh/.zsh_*` → `*.zsh`; remove the manual edit; verify
   a fresh shell still loads everything.
3. **Track real state:** add `~/.zshrc`, `~/.zprofile`, `~/.gitconfig` (split into
   base + local). De-duplicate (esp. the ×5 brew lines).
4. **Make it installable:** add a `Brewfile` + a real `install.sh` (symlink + `brew
   bundle` + macOS defaults). Target: `git clone && ./install.sh`.
5. **Split work/personal** per the architecture above.
6. **Prune dead weight:** remove/archive `bash/`, `hyper/`, `sublime/`; add `.gitignore`.
7. **Optional modernization:** consider [`starship`](https://starship.rs) (faster,
   actively maintained) over Powerline Shell; consider [`fnm`](https://github.com/Schniz/fnm)
   over NVM for speed; consider [`chezmoi`](https://www.chezmoi.io) if you want
   templated, multi-machine, secret-aware management out of the box.

Target end state: **clone the repo, run one command, restore secrets from 1Password,
done** — with a clean, auditable line between Puzzle and personal.
