---
name: architecture-review
description: Use when reviewing branch changes for architectural compliance, checking layer boundaries, validating module-driven design conventions, or before merging feature branches
disable-model-invocation: true
---

# Architecture Review

## Overview

Dispatches the `ar-agent` to review the current branch's changes against your frontend architecture (DDD-inspired layer boundaries and module/feature separation). The agent produces findings, refactoring options, and a concrete recommendation written to `plan/architecture-review.md`.

## When to Use

- Before merging a feature branch
- When checking if changes respect layer boundaries
- When validating module vs feature separation
- When reviewing data-fetching placement or import direction

## Workflow

### Step 1: Determine Scope

Figure out what the user wants reviewed:

- **Specific files/folders:** The user provided explicit paths to review
- **Full branch review:** Everything else (default)

### Step 2: Dispatch ar-agent

Dispatch the `ar-agent` via the Task tool with a prompt that includes:

1. **The scope** — either the specific files/folders provided, or "perform a full branch review"
2. **Any user context** — specific concerns, areas of focus, or architectural questions

The ar-agent handles everything autonomously: generating the diff, reading architecture docs, analyzing, and writing the review.

### Step 3: Present Results

When the ar-agent returns, summarize the review to the user:

1. Key findings (highest-impact items)
2. The recommended refactoring option
3. Note where the full review is written (`plan/architecture-review.md`)
