---
name: create-rfc
description: Use when authoring a new RFC, design doc, or technical proposal — proposing an architecture change, feature/domain boundary, migration, refactor, seam, or tooling change that needs a written, reviewable design before implementation. Produces an RFC in the house format used in plan/marcos/rfcs.
---

# Create RFC

Write a new RFC in the author's house format: measured, data-driven, and structured so a reviewer can find the decision, the stakes, and the definition of done fast. The full section template and tone rules live in `template.md` — read it before drafting.

## When to use

- "Let's write an RFC / design doc / proposal for X"
- Proposing a non-trivial change that others should review before it's built: an architecture or DDD-boundary change, a migration, a refactor across a seam, a tooling/lint change.
- **Not for**: a single-PR mechanical change (just do it), or a spec/ticket breakdown (that's `to-spec` / `to-tickets`).

## Process

1. **Ground it in measurement first.** Read the code, docs, and config the RFC touches. Get the real numbers — counts, file lists, the current seam inventory — the way the corpus does (ripgrep over production sources, excluding tests/stories/mocks; name the method). An RFC full of adjectives instead of counts is not in house style. If a number needs work to obtain, that's a plan step, not a guess.
2. **Collect the edges.** Find the related RFCs, the strategy doc, the Linear issue, and the architecture reference to link. Every RFC sits in a web of prior decisions. Use http valid URLs for the doc links, so they are valid when we paste the RFC into Notion.
3. **Pick the shape.** Light (component / migration / token rework) vs. full (architecture / boundary / seam). `template.md` lists which sections each needs.
4. **Draft from `template.md`.** Fill every section; delete inapplicable ones deliberately. Tables for inventories, preference-ordered options, exit criteria as checkboxes with `**N** (from M)` before→after numbers, and a because-clause on every structural choice.
5. **Name it first, before drafting.** Decide the target path — `<RFC-dir>/<STATUS>-<kebab-title>.md` (NEXT / WIP / WAIT / DELEGATED prefix; `plan/marcos/rfcs/` unless the repo keeps RFCs elsewhere) — and state it on the first line of the deliverable as `File: <path>`. Then open the doc with the metadata header (Author, Status, Created, Updated, Related). Do not hand over an RFC without a filename.
6. **Self-check** against the checklist below before handing it over.

## Quick reference — the skeleton

Metadata header → Summary/TL;DR → Background → Problem → Goals → Non-goals → **[Current Seam → Proposal → Placement → Implementation Plan → Tradeoffs Behavior → Invariants → Manual Testing]** → Alternatives Considered → Risks and Mitigations → Exit criteria → Rollout → Open Questions.

Bracketed sections are the full-RFC additions; a light RFC can drop them. Full detail and per-section guidance: `template.md`.

## Checklist

- [ ] Deliverable opens with `File: <RFC-dir>/<STATUS>-<kebab-title>.md`; metadata header present and dated.
- [ ] Summary states the decision and the headline numbers in the first few sentences.
- [ ] Every current-state claim carries a count and how it was measured.
- [ ] Non-goals section points deferred scope at where it actually lives.
- [ ] Options are preference-ordered; every structural choice has a because-clause.
- [ ] Inventories are tables, not prose.
- [ ] Exit criteria are falsifiable checkboxes with before→after numbers.
- [ ] Related RFCs / strategy / Linear / architecture docs are linked.

## Common mistakes

- **Adjectives instead of measurements** — "many violations" where the corpus would say "164 across 58 pairs". Measure first.
- **Background and Problem saying the same thing** — Background is the measured state; Problem is the concrete harm it causes.
- **Vague done-ness** — "improve boundaries" instead of `imports: 0 (from 164)`.
- **Orphan RFC** — no links to the strategy doc, related RFCs, or tracking issue.
- **Reaching for the full template on a light change** — it reads as ceremony. Match the shape to the work.
- **No hard-wrapped markdown lines** - Each paragraph should be one physical line, with blank lines only between paragraphs.
