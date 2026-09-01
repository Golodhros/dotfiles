# Dotfiles Assessment & Improvement Roadmap

_Last reviewed: 2026-06-04 · Updated: 2026-09-01_

Goal driving this assessment: **(1)** stand up a new dev machine quickly and repeatably,
and **(2)** keep a clean separation between Puzzle (work) and personal concerns.

## Update (2026-09-01): fnm replaces NVM, and the repo goes zsh-only

Work is now at **accrual**, which standardises on [`fnm`](https://github.com/Schniz/fnm)
rather than NVM. A version manager is a per-machine choice, so it no longer lives in the
repo at all — the repo is version-manager-agnostic and `~/.extra` picks one.

- ✅ **NVM removed from the repo.** Dropped the `NVM_DIR` load and the hand-rolled
  `load-nvmrc` chpwd hook from `zsh/shell.zsh`, and the "Installing NVM" step from
  `install.sh` (later steps renumbered 6–10 → 5–9). `Brewfile` and `README.md` updated.
- ✅ **fnm set up in `~/.extra`** (untracked):
  `eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell zsh)"`.
  `--use-on-cd` replaces the hand-rolled hook; `--version-file-strategy=recursive` finds a
  `.nvmrc` / `.node-version` in parent directories, so it works from any package inside a
  monorepo. Both accrual repos pin `v24.20.0` via `.node-version`; that version is
  installed and set as the fnm default.
  - ⚠️ **Gotcha worth remembering:** with the Homebrew install, `FNM_DIR` defaults to
    `~/.local/share/fnm`, *not* the `~/Library/Application Support/fnm` path fnm's
    curl-installer docs use. Don't put that path on `PATH` and don't override `FNM_DIR` —
    installing a Node version under the wrong root makes `use-on-cd` fail at runtime with
    "Requested version v24.20.0 is not currently installed".
- ✅ **`bash/` deleted** — zsh-only now, no going back. Every alias and function in
  `bash/.bash_aliases` already existed in `zsh/aliases.zsh`, so nothing was lost.
  Resolves the `bash/` half of issue 7.
- ✅ **Vendored git completion deleted — this *fixed* `git <TAB>`, which was broken.**
  Removed `git/.git-completion.bash` (78K), `git/.git-completion.zsh` (7K),
  `git/.completion`, and its `source` line in `zsh/profile.zsh`.

Verified in a clean login shell: `node` resolves through fnm to v24.20.0 both at `$HOME`
and inside a repo pinned by `.node-version`.

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
  _(`bash/` was subsequently deleted on 2026-09-01.)_

**Intentionally deferred:** the secrets hardening (issue #1) — `~/.extra` stays a manual,
1Password-restored file. **Not done in this pass:** Windows automation (Mac-only by
choice). Remaining optional ideas are in the roadmap below.

## Executive Summary

_Rewritten 2026-09-01. The original June assessment survives in the dated Update sections
above; the issue list below is annotated with what has since been fixed._

The repo is an **installer now, not a manual reference**: `git clone && ./install.sh` takes
a new Mac to a working shell, the real `~/.zshrc` / `~/.zprofile` / `~/.gitconfig` are
tracked, and the Oh My Zsh source patch is gone. Dead weight (`sublime/`, then `bash/`) has
been removed and the shell story is zsh-only.

What's left is the boundary, not the bootstrap. `~/.extra` is still a single untracked
plaintext file holding live credentials with no restore path — the one genuinely
high-severity item, and still deferred. Issue 3 (work and personal tangled in that one
file) is the other open structural item; anything machine-specific belongs there rather
than in a tracked file.

---

## What's Good

- **Clear modular split** of concerns into `zsh/`, `git/`, `osx/`, etc.
- **`~/.extra` seam** for machine-specific config is the right idea — secrets and
  work config are kept *out* of the committed repo.
- **Automatic per-project Node switching** (NVM then, fnm via `~/.extra` now), useful
  git aliases, sensible macOS defaults.
- **`DOTFILES` env var** indirection makes paths portable.

---

## Issues (by severity)

### 🔴 High

1. ~~**Fragile Oh My Zsh source patch.**~~ ✅ **Resolved 2026-06-05.** Setup requires editing
   `~/.oh-my-zsh/oh-my-zsh.sh` (the `for config_file ("$ZSH_CUSTOM"/.*)` line). Any
   `omz update` reverts it, silently disabling all `zsh/` config. This is also the
   single most confusing part of a fresh setup.
   - **Fix:** rename the `zsh/` files to the convention Oh My Zsh already loads
     (`*.zsh`, e.g. `aliases.zsh`, `prompt.zsh`, `profile.zsh`) and delete the patch
     entirely. No more editing OMZ internals.

### 🟠 Medium

2. ~~**Repo is not an installer; real config has drifted.**~~ ✅ **Resolved 2026-06-05.** `install.sh` is almost
   entirely commented out (only runs `osx/set-defaults.sh`). The actually-loaded
   `~/.zshrc` and `~/.zprofile` and `~/.gitconfig` are **not tracked**, so the repo
   doesn't capture the real state. New-machine setup is 100% manual.
   - **Fix:** add a real `install.sh` (or [`stow`](https://www.gnu.org/software/stow/) /
     [Dotbot](https://github.com/anishathalye/dotbot)) that symlinks tracked files and a
     `Brewfile` (`brew bundle`) that installs tooling.

3. **Work/personal not actually separated.** Everything — personal tooling *and* Work
   secrets/aliases — is jammed into one untracked `~/.extra`. There's no boundary.
   - **Fix:** split into layered, explicit files (see "Proposed Architecture").

4. **Duplication across files.** Same logic defined in multiple places:
   - Powerline prompt hook: `zsh/.zsh_prompt` **and** `~/.extra`.
   - NVM load: `zsh/.zshrc`, `~/.extra`, **and** `bash/.bashrc`. — ✅ resolved 2026-09-01;
     the repo now defines no version manager, only `~/.extra` does.
   - Bashmarks: `zsh/.zshrc` **and** `~/.extra`.
   - Homebrew `shellenv`: `~/.zprofile` (×5!) **and** `~/.extra`. — ✅ resolved; `~/.zprofile`
     defines it once and `.zshrc` only fills in for non-login shells (2026-09-01).
   - `~/.zprofile` literally repeats `eval "$(brew shellenv)"` five times.
   - `zsh/.zsh_aliases` defines `alias path=...` twice and `~/.extra` has the
     `unsetopt inc_append_history`/`share_history` block twice.
   - **Fix:** single source of truth per concern; delete the copies.

### 🟡 Low / hygiene

5. **Dead weight inflating the repo and setup:**
   - `sublime/` — large, includes bundled binaries (`ColorPicker_*`), theme packs, an
     `.SublimeREPLHistory/`, and a committed `.DS_Store`. Almost certainly unused now.
   - **Fix:** delete or move to an `archive/` branch/dir.
6. **`.zshenv` and `.dotfiles_env` are byte-identical** — keep one.
7. **Hardcoded absolute paths** (`/Users/miglesias/...`) in `vscode/instructions.txt`
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

~/.config/dotfiles/personal.sh   → personal tooling (bashmarks, powerline; Node manager per machine)
~/.config/dotfiles/work.sh       → Work aliases + non-secret config            [untracked]
~/.config/dotfiles/work.secrets  → Work secrets, sourced from 1Password        [untracked, never committed]
extra.example                    → committed template documenting every var above
```

Conditional work loading (so a personal machine never tries to load Work config):

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

2. **Kill the OMZ patch:** rename `zsh/.zsh_*` → `*.zsh`; remove the manual edit; verify
   a fresh shell still loads everything.
3. **Track real state:** add `~/.zshrc`, `~/.zprofile`, `~/.gitconfig` (split into
   base + local). De-duplicate (esp. the ×5 brew lines).
4. **Make it installable:** add a `Brewfile` + a real `install.sh` (symlink + `brew
   bundle` + macOS defaults). Target: `git clone && ./install.sh`.
5. **Split work/personal** per the architecture above.
6. ~~**Prune dead weight:** remove/archive `bash/`; add `.gitignore`.~~ ✅ done
   (`sublime/` 2026-06-05, `.gitignore` 2026-06-05, `bash/` 2026-09-01).
7. **Optional modernization:** ✅ `fnm` over NVM — done 2026-09-01, via `~/.extra` rather
   than the repo (see the update at the top). Still open: consider
   [`starship`](https://starship.rs) (faster, actively maintained) over Powerline Shell,
   and [`chezmoi`](https://www.chezmoi.io) if you want templated, multi-machine,
   secret-aware management out of the box.

Target end state: **clone the repo, run one command, restore secrets from 1Password,
done** — with a clean, auditable line between Work and personal.
