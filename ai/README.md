# ai/ — Personal AI Development Skills & Agents

A tool-agnostic library of Claude Code **skills** and **agents** I've built for
AI-assisted frontend development: code review, architecture review, testing, docs,
DRY/style checks, story generation, and a quality umbrella that runs several at once.

These are **genericized** — all company/project-specific names, commands, and internal
doc paths have been replaced with neutral placeholders (`@org/*`, `@app/modules`,
`pnpm check:changed`, `pnpm gen`, "your styleguide / architecture / error-handling
guide", etc.). Adapt the placeholders to whatever project you drop them into.

## How it works

Definitions live here once (`ai/skills/`, `ai/agents/`). To use them in a project, you
**symlink** the ones you want into that project's `.claude/` directory. The symlinks
point back here, so editing a definition updates every project that links it.

```bash
# from the target project's root:
~/.dotfiles/ai/link.sh --list                       # see what's available
~/.dotfiles/ai/link.sh --all                        # link everything
~/.dotfiles/ai/link.sh code-review quality unit-test # link specific skills (+ their agents)
~/.dotfiles/ai/link.sh --agent knip-agent           # link a standalone agent
```

`link.sh` creates `.claude/skills/<name>` and `.claude/agents/<name>.md` symlinks, and
automatically links the agents a skill depends on. Add `.claude/skills/` and
`.claude/agents/` to the project's `.gitignore` so your local selection isn't committed.

To remove: `rm .claude/skills/<name>` / `rm .claude/agents/<name>.md` (only deletes the
link, never the source here).

## Skill → agent dependency map

| Skill | Dispatches agents |
|-------|-------------------|
| `/architecture-review` | `ar-agent` |
| `/audit-changes` | (none) |
| `/build` | (none — orchestrates other skills) |
| `/code-review` | `cr-agent` |
| `/create-story` | `story-agent` |
| `/document` | `doc-agent` |
| `/dry-review` | `dry-agent` |
| `/quality` | `cr-agent`, `ar-agent`, `dry-agent`, `style-agent` |
| `/rfc-review` | (none) |
| `/style-review` | `style-agent` |
| `/unit-test` | `ut-agent` |
| `/verify-issues` | (none) |

**Standalone agents** (run directly, not tied to a skill here): `knip-agent`
(unused-code review), `readme-auditor` (README coverage audit).

## What's inside

**Agents** (`ai/agents/`): `ar-agent` (architecture), `cr-agent` (code review),
`doc-agent` (Diátaxis docs), `dry-agent` (duplication), `knip-agent` (dead code),
`readme-auditor`, `story-agent` (Storybook), `style-agent`, `ut-agent` (unit tests).

**Skills** (`ai/skills/`): `architecture-review`, `audit-changes`, `build`,
`code-review`, `create-story`, `document`, `dry-review`, `quality`, `rfc-review`,
`style-review`, `unit-test`, `verify-issues`.

## Placeholders to adapt per project

| Placeholder | Means |
|---|---|
| `@org/test-utils` | your shared test utilities package |
| `@app/modules`, `apps/<app>/modules/<name>/` | your module/feature folders |
| `pnpm check:changed` | your changed-file validation (lint + type-check + tests) |
| `pnpm gen` | your code generation step (e.g. GraphQL codegen) |
| `STYLEGUIDE.md`, "your architecture/error-handling/testing guide" | your project's docs (optional — skills skip them if absent) |
| `plan/` | where review findings are written |
