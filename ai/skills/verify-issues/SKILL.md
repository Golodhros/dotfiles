---
name: verify-issues
description: Use when receiving code review feedback or reported issues — verifies the issue, checks if it warrants an ESLint rule, and presents actionable options
disable-model-invocation: true

---

# Verify Issues

## Overview

Triages code review feedback or reported issues: verifies the problem is real, evaluates whether it's an ESLint rule candidate, checks existing lint rules, and presents actionable options with a recommendation. Does NOT implement fixes — only analyzes and proposes.

## When to Use

- After receiving code review feedback (from cr-agent, PR review, or a collaborator)
- After receiving style review findings (from `/style-review` or `/quality`)
- When someone reports an issue or pattern concern in the code
- When you want to evaluate whether a problem should become a lint rule

## Workflow

### Step 1: Verify the Issue

Read the feedback and verify:
- Does the issue actually exist in the code?
- Is it a real problem (not a false positive or misunderstanding)?
- What is the actual impact?

If the issue does not exist or is not a real problem, report that and stop.

### Step 2: Evaluate as ESLint Rule Candidate

If the issue is real, ask:
- Could we lint for this to prevent future similar issues?
- Is the pattern common enough to warrant a rule? (Don't lint for rare one-offs)
- Would it cause many false positives?
- For style review findings: is this already covered by an existing rule, or does the style guide convention need enforcement?

Be biased toward creating rules — catching future issues is more valuable than the effort to write the rule. But balance that against false-positive risk.

### Step 3: Examine Existing Lint Rules

**Only if Step 2 concluded it's a good rule candidate:**

1. Check your project's custom ESLint ruleset directory for existing rules
2. Determine if a rule already exists that covers this, or find the right place for a new one
3. Consult your ESLint rule authoring guide for implementation guidance, if it exists
4. Determine which ruleset it belongs in based on its technology dependency:
   - General/app-specific: your general ruleset
   - Technology-specific: the appropriate technology-specific ruleset

### Step 4: Present Options

Summarize the problem in clear, natural language (no code snippets). Then present options:

- Only include **reasonable** choices — no obviously inferior or over-complicated options
- For each option: pros, cons, and tests that need updating
- Present as a **single column of formatted text**, not a table
- If there is only one good choice, present just that one
- End with your **recommendation**, reasoning, and how you'd mitigate its cons

**Do NOT implement any changes.** This skill is analysis-only. The user decides which option to pursue and when to implement.

**Do NOT run `pnpm check:changed`** after this skill completes — the user may be processing multiple issues in parallel and will validate later.

## Common Mistakes

- Implementing fixes before the user chooses — this skill is analysis-only
- Dismissing ESLint rule candidates too quickly — bias toward preventing future issues
- Including code snippets in the summary — use plain language instead
- Running changed-file validation — the user may be working in parallel
