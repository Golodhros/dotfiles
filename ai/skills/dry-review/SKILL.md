---
name: dry-review
description: Use when checking branch changes for duplicated logic, reimplemented utilities, or copy-pasted code that already exists elsewhere in the codebase
disable-model-invocation: true

---

# DRY Review

## Overview

Dispatches the `dry-agent` to scan the branch diff against the **whole codebase** to find redundant code: duplicated logic, reimplemented utilities, and copy-pasted mocks. The agent produces findings written to `plan/dry-review.md`.

## When to Use

- As part of the `/quality` gate (runs automatically alongside other reviews)
- Standalone when you suspect you may have reinvented something that exists in the codebase

## Workflow

### Step 1: Dispatch dry-agent

Dispatch the `dry-agent` via the Task tool with a prompt that includes:

1. **The scope** — "perform a full branch review" (default) or specific concerns the user mentioned
2. **Any user context** — particular areas of suspected duplication, or files of interest

The dry-agent handles everything autonomously: generating the diff, extracting new code, searching the codebase for existing implementations, and writing findings.

### Step 2: Present Results

When the dry-agent returns, summarize the findings to the user:

1. Total number of findings
2. List each finding with its recommendation (use existing / consolidate / keep as-is)
3. Note where the full findings are written (`plan/dry-review.md`)
