# RFC template

Copy the skeleton below into a new file and fill every section. Delete sections that genuinely don't apply, but delete them deliberately — an empty "Risks" section is a smell, not a shortcut.

Two shapes share one skeleton:

- **Light RFC** (a single component, a migration, a token rework): Metadata → Background → Problem → Proposal → Pros/Cons → Alternatives → Migration plan → Risks → Next steps → Decision.
- **Full RFC** (an architecture change, a feature/domain boundary, a seam): the light set **plus** Current Seam, Placement / target graph, Implementation Plan, Behavior Invariants, Testing Strategy, Exit criteria, Verification.

Pick the shape from the work, not the other way around.

## Filename & status convention

Live under the RFC directory (e.g. `plan/marcos/rfcs/`) as `<STATUS>-<kebab-title>.md`:

| Prefix | Meaning |
| --- | --- |
| `NEXT-` | Ready to pick up next |
| `WIP-` | Being implemented now |
| `WAIT-` | Blocked / parked on a dependency |
| `DELEGATED-` | Handed to someone/an agent |
| `Postponed/` | Moved into the Postponed dir |
| `Archive/DONE-` | Completed; moved into Archive |

The `**Status:**` line inside the doc (`Proposed` / `Accepted` / `Implemented`) tracks review state; the filename prefix tracks scheduling state. Keep both current.

## Skeleton

```markdown
# RFC: <Title> — <one-line descriptive subtitle>

**Author:** Marcos Iglesias
**Status:** Proposed
**Created:** YYYY-MM-DD
**Updated:** YYYY-MM-DD — <what changed this revision>
**Related:**

* [<strategy doc>](../strategy/…)
* [<other RFC>](./…)
* [<LINEAR-ID>](https://linear.app/…)
* [Architecture](../../../docs/reference/architecture.md)

## Summary        <!-- "## TL;DR" for long RFCs -->
2–4 sentences: what changes, why now, and the shape of the proposal. A reader who
stops here should know the decision and the stakes. State the headline numbers.

## Background
The measured state of the world today. Cite exact figures and how they were counted
("164 production cross-feature imports across 58 directed pairs, ripgrep over
production sources excluding tests"). Link the assessment / strategy doc this comes from.

## Problem
Numbered list. Each item is a concrete failure the current state causes, not a
restatement of Background. Say who feels it and when.

## Goals
Bullet list of what success delivers. Outcomes, not tasks.

## Non-goals
What this RFC explicitly does NOT do, and where that work lives instead (link the
other RFC/phase). This is where scope creep goes to die — be generous with it.

<!-- ── Full-RFC sections (architecture / boundary / seam) ── -->

## Current Seam        <!-- or "Current Seam Inventory" -->
Table of what exists today at the boundary being changed: files, import counts,
owners. This is the before-picture the Exit criteria measure against.

## Proposal
The meat. For multi-part work, break into `### Workstream N — <verb phrase>` or
`### Phase N`. For each: what changes, the resolution rule, and WHY this over the
alternatives. Use tables for cluster/inventory breakdowns. Order options by
preference and say so ("in preference order: 1. move down, 2. merge, 3. supervised seam").

## Placement        <!-- or "Target dependency graph" / "Proposed Data Flow" -->
Where things end up. A dependency graph, a folder end-state, or a data-flow diagram.

## Implementation Plan        <!-- or "Migration Plan" -->
Ordered steps or a suggested PR breakdown. Each PR should be independently landable
and reviewable. Note which steps are mechanical vs. team-level decisions.

## Tradeoffs        <!-- or "Pros / Cons" / "Consequences" -->
**Benefits** / **Costs**. What the team is buying and what it's paying.

## Behavior Invariants
What must NOT change for users/callers as a result of this work. The contract the
refactor preserves.

## Testing Plan
How correctness is proven by users in the application (manual QA).

<!-- ── Shared closing sections ── -->

## Alternatives Considered
Each real alternative, why it was rejected. "Do nothing" is a valid entry when the
status quo is tenable. Concisely mention the tradeoffs for each one.

## Risks and Mitigations
Table or list: risk → likelihood/impact → mitigation. Be honest about the ones you
can't fully mitigate.

## Exit criteria        <!-- or "Completion Criteria" / "Acceptance Criteria" -->
Checklist with before→after numbers so "done" is unambiguous:
- [ ] Production cross-feature imports: **0** (from 164)
- [ ] `eslint-disable` for the rule: **0** (from 7)
- [ ] The ratchet allowlist file is deleted

## Rollout        <!-- or "Rollout order" -->
Landing order and why. Flag anything gated on a flag, a migration, or coordination.

## Open Questions
Unresolved decisions that need input before or during implementation. Delete if none.
```

## Tone & house rules

- **Data over adjectives.** Every claim about the current state carries a number and how it was measured. "Lots of violations" → "164 production imports across 58 pairs (ripgrep, excluding tests)". If you can't measure it yet, that's a step in the plan, not a sentence in the RFC.
- **Tables for inventories.** Clusters, file lists, before/after counts → tables, not prose.
- **Options are preference-ordered.** When you list resolutions, rank them and name the ranking.
- **Exit criteria are falsifiable.** Checkboxes with `**N** (from M)`, not "improve X".
- **Link the graph.** Related RFCs, the strategy doc, the Linear issue, the architecture reference — every RFC sits in a web of decisions; show the edges.
- **Justify, don't assert.** "This ordering makes the flip cheap and immediate: new violations become impossible day one, while existing debt burns down on its own schedule." Every structural choice earns a because-clause.
- **Non-goals do real work.** Most scope disputes are settled by a crisp Non-goals section that points at where the deferred work lives.
