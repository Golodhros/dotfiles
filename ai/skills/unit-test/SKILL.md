---
name: unit-test
description: Use when you need to create, run, update, or debug unit tests — dispatches the ut-agent for autonomous test work
disable-model-invocation: true

---

# Unit Test

## Overview

Dispatches the `ut-agent` to handle unit test work: writing new tests, running existing tests, debugging failures, or improving coverage. The agent follows your testing guide conventions (if it exists).

## When to Use

- After creating or modifying a component, hook, or utility
- When tests are failing and need debugging
- When you want to improve test coverage for a specific area
- When refactoring tests to follow current best practices

## Workflow

### Step 1: Determine Intent

Figure out what the user needs:

- **Create tests:** User wrote new code and needs tests for it
- **Run tests:** User wants to execute tests and see results
- **Debug tests:** Tests are failing and need diagnosis
- **Update tests:** Code changed and existing tests need updating

### Step 2: Dispatch ut-agent

Dispatch the `ut-agent` via the Task tool with a prompt that includes:

1. **The intent** — create, run, debug, or update
2. **Target files** — specific files, folders, or features the user mentioned
3. **Any context** — error messages, recent changes, or specific concerns

The ut-agent handles everything autonomously: reading test guides, writing tests, running them, and fixing failures.

### Step 3: Present Results

When the ut-agent returns, summarize the results to the user:

1. What was done (tests created, run, fixed, etc.)
2. Test results (passed/failed/skipped counts)
3. Any remaining issues or coverage gaps noted
