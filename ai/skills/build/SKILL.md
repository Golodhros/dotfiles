---
name: build
description: Use when executing an implementation plan — runs the plan step by step, adds files to ESLint opt-in, runs changed-file validation, and generates the branch diff
model: opus
disable-model-invocation: true

---

# Build

## Overview

Executes the implementation plan at `plan/2-implementation-plan.md` step by step, then validates the work with changed-file checks and generates the branch diff.

## Pre-flight Check

1. Check the current branch with `git branch --show-current`
2. If on `master` or `main`, **stop** and ask the user to create a feature branch first
3. Read `plan/2-implementation-plan.md` — if it doesn't exist, stop and tell the user to create one (see `/rfc-review`)

## Workflow

Execute each item under "Implementation Order" in the plan as a task list. After completing each step, run `pnpm check:changed` (your changed-file validation: lint + type-check + tests).

After completing all plan steps, append these final steps:

### Final Step 1: ESLint Opt-In

If your project uses an ESLint opt-in file list, ensure all relevant changed files have been added to it. Check which new or moved `.ts`/`.tsx` files were created and add them to the opt-in list if they aren't already covered by an existing glob pattern.

### Final Step 2: Generate Diff

Get the branch diff with `git diff $(git merge-base HEAD main)...HEAD` so the `/quality` skill can review it later.

### Final Step 3: Quality review

Invoke the `/quality` skill.

**IMPORTANT:** Try to solve problems without disabling or changing any linter rules. If disabling or changing a linter rule seems like the best path forward, ask the user for permission first.


## Common Mistakes

- Starting work on `master`/`main` instead of a feature branch
- Disabling lint rules without asking — always ask first
- Forgetting to add new files to the ESLint opt-in list (if your project uses one)
- Stopping at the first validation failure instead of fixing until green
