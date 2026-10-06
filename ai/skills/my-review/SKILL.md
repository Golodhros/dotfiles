---
name: my-review
description: Personal review checklist for one feature folder of the current repo, named by $SKILLS_TEST_GROUND_PATH. Use when the user runs /my-review after working inside that folder.
---

# /my-review

A personal checklist, run on one feature folder after a piece of work. It
reports; it does not fix unless the user says so.

## Where it looks

Two environment variables, set in `~/.extra`, never in this file:

- `SKILLS_TEST_GROUND_PATH` (required): the feature folder, relative to the
  repo root. Call it `F/` below.
- `SKILLS_TEST_GROUND_SKIP` (optional): colon-separated subpaths of `F/` to
  leave out, for parts of the feature whose conventions are still open.

Resolve both first:

```bash
echo "F=${SKILLS_TEST_GROUND_PATH:?set SKILLS_TEST_GROUND_PATH in ~/.extra}"
echo "skip=${SKILLS_TEST_GROUND_SKIP:-}"
```

If the variable is unset, say so and stop. Do not guess a folder.

## Scope

- No argument: the branch's change set under `F/`. Working tree plus commits
  since the merge base with `main`:
  `git diff --name-only $(git merge-base HEAD origin/main) -- $F`, plus
  `git diff --name-only -- $F`, plus untracked files from
  `git status --porcelain -- $F`.
- With a path argument (`/my-review F/some/+components`): that path, whatever
  its git state. A path that does not start with `F/` is out of scope; say so.
- Only `.ts` and `.tsx`. Skip `F/+lib/copy.ts`, every `*.test.*`, and every
  subpath in `SKILLS_TEST_GROUND_SKIP`.

If the scope is empty, say so and stop.

## Checks

Run every check. Report each finding as `file:line`, the offending text, and
the fix. Group by check. End with a one-line count per check. When a check
finds nothing, say so in one line.

### 1. User-facing copy comes from `COPY`

Every string a user can read is a property of the `COPY` object exported from
`F/+lib/copy.ts`, reached by a relative import. A component or route file
never holds a bare literal for one, and never exports its own
`*_TITLE`/`*_LABEL` constant for another file to import.

First pass, mechanical. Run it, then read each hit:

```bash
grep -nE "(title|caption|label|placeholder|subtitle|heading|emptyLabel|emptyTitle|description|message|aria-label|aria-description)=['\"][A-Za-z]|(toast\.(error|success|info|warning)|confirm)\(\s*['\"]|^\s*>?[A-Z][a-z].*<" <files>
```

Then look for what the grep misses:
- JSX text children: `<p>Nothing selected</p>`, `<span>Save</span>`.
- Literals inside `useMemo`/`map` row builders: `title: 'Procedures'`.
- Template strings that render to the user: `` `${count} items` ``.
- Fallbacks: `?? 'Unknown'`, `|| 'Untitled'`.
- Exported string constants whose name ends in `_TITLE`, `_LABEL`, `_CAPTION`.

Not a finding:
- `data-*` attributes, `className`, `key`, `id`, `name` (form field names),
  route paths, query keys, enum/discriminant literals, `aria-*` values that
  are ids, type-level string indexes (`['control']`).
- Punctuation or layout-only text: `·`, `—`, `/`, `(`, `)`, `:`.
- A literal already read from `COPY` through a variable.

For each finding, name the `COPY` namespace it belongs in. The namespaces are
the top-level keys of `copy.ts`; read the file before suggesting one, and
propose a new key only when no existing one fits the surface the literal
belongs to.

## Adding a check

Add a `### N. <rule>` section under Checks: the rule in one or two sentences,
a mechanical first pass if one exists, what the pass misses, what is not a
finding. Keep the sections numbered in the order they were added. Keep repo
names, product names, and paths out of this file; they go in `~/.extra`.
