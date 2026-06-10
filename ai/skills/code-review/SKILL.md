---
name: code-review
description: Use when reviewing branch changes or unstaged changes for logic errors, unclear intent, and code quality issues before merging or committing
disable-model-invocation: true
---

# Code Review

## Overview

Dispatches the `cr-agent` to perform a meticulous code review focused on logic, functionality, and clarity of intent. The agent produces prioritized findings (P0-P4) written to individual files in `plan/`.

## When to Use

- Before merging a feature branch (full branch review)
- Before committing work-in-progress (unstaged-only review)
- When you want a second pair of eyes on changed code

## Workflow

### Step 1: Determine Scope

Figure out what the user wants reviewed:

- **Unstaged changes only:** The user explicitly asked for unstaged/uncommitted changes
- **Full branch review:** Everything else (default)

### Step 2: Dispatch cr-agent

Dispatch the `cr-agent` via the Task tool with a prompt that includes:

1. **The scope** — either "review unstaged changes only" or "perform a full branch review"
2. **Any user context** — specific concerns, areas of focus, or files the user mentioned

The cr-agent handles everything autonomously: generating the diff, reading plan context, reviewing, and writing findings.

### Step 3: Present Results

When the cr-agent returns, summarize the findings to the user:

1. Total number of findings by priority level (P0, P1, P2, etc.)
2. List any **P0 or P1 issues** with their titles and locations
3. Note where the full findings are written (`plan/cr-<batch>-*.md`)
