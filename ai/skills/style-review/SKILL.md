---
name: style-review
description: Use when checking branch changes for style guide violations — validates code against your styleguide conventions for JS, TS, styles, tests, and file organization
disable-model-invocation: true

---

# Style Review

## Overview

Dispatches the `style-agent` to scan the branch diff against your styleguide (`STYLEGUIDE.md` if it exists) and find style guide violations in new or modified code. The agent produces prioritized findings (S1-S3) written to `plan/style-review.md`.

## When to Use

- As part of the `/quality` gate (runs automatically alongside other reviews)
- Standalone when you want to check if your changes follow your style conventions

## Workflow

### Step 1: Dispatch style-agent

Dispatch the `style-agent` via the Task tool with a prompt that includes:

1. **The scope** — "perform a full branch review" (default) or specific concerns the user mentioned
2. **Any user context** — particular style areas to focus on, or files of interest

The style-agent handles everything autonomously: generating the diff, reading the style guide, reviewing, and writing findings.

### Step 2: Present Results

When the style-agent returns, summarize the findings to the user:

1. Total number of findings by severity (S1, S2, S3)
2. List any **S1 violations** with their titles and locations
3. Note where the full findings are written (`plan/style-review.md`)
