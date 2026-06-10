---
name: document
description: Use when documenting changes before wrapping up some significant work
disable-model-invocation: true

---

# Document

## Overview

Documentation pipeline that dispatches the `doc-agent` to update READMEs, JSDoc, and hook Result types for code changed in the current branch.

## When to Use

- After finishing implementation, before or after `/quality`
- When you've changed modules or features and want documentation to match

## Workflow

### Step 1: Identify Changed Modules and Features

1. Run `git merge-base HEAD main` first to get the merge base SHA, then run `git diff --name-only <SHA>...HEAD` using the result (avoid `$()` command substitution to prevent permission prompts)
2. Extract unique module and feature folders from the changed file paths:
   - Modules: paths matching `apps/<app>/modules/<name>/`
   - Features: paths matching `apps/<app>/features/<name>/`
3. If no modules or features were changed, check unstaged changes with `git diff --name-only`

### Step 2: Dispatch doc-agent for READMEs

For each changed module and feature, dispatch the **doc-agent** via the Task tool:

- If a README.md exists: "Update the README for `@app/modules/<name>/` to reflect the current code"
- If no README.md exists: "Create a README for `@app/modules/<name>/` following the module template"

Dispatch one doc-agent per module/feature. Run them in parallel when possible.

### Step 3: Dispatch doc-agent for JSDoc and Hook Result Types

For each changed module and feature, dispatch the **doc-agent** with:

- "Add or update JSDoc on changed utils, entry-point components, and custom hooks in `<folder>/`. Document hook Result types. Only touch files changed in this branch. Do NOT modify TypeScript return type annotations — only add JSDoc comments."

### Step 4: Verify

After all doc-agent dispatches complete:

1. Spot-check that READMEs reflect the actual folder structure and exports
2. Verify JSDoc `@param` and `@returns` match current TypeScript signatures
3. Confirm no stale documentation was left behind

## Common Mistakes

- Documenting the entire codebase instead of scoping to changed files only
- Adding or changing TypeScript return type annotations — only add JSDoc, never modify type signatures
