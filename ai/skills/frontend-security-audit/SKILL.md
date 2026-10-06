---
name: frontend-security-audit
description: Perform an OWASP-based, read-only security audit of the Epsilon frontend on main, verify reachable vulnerabilities and shipped dependency advisories, compare with the previous audit, and publish an AIM report.
---

# Frontend Security Audit

Audit the browser-delivered code in `accrual-dev/epsilon` on `main`. Find vulnerability indicators, confirm their reachability, and publish one severity-ranked report as an AIM document plus a concise chat reply.

This skill is adapted from the [Frontend Security Audit routine](https://arc.accrual.dev/routines/rout_sys_frontend_security_audit), whose [built-in definition](https://github.com/accrual-dev/aim/blob/main/packages/built-ins/src/routines/frontend-security-audit.ts) runs weekly with cron `0 7 * * 0`. The skill performs one audit per invocation; scheduling remains outside the skill.

## Scope and boundaries

- There is no target pull request. Do not ask for a PR URL or number, open or complete an `AIM Code Review` check run, submit a PR review, or post GitHub comments.
- Keep the audit read-only. No production access, code changes, commits, pushes, fix branches, or pull requests, including drafts. Saving the requested audit document is the output operation. If a finding warrants an immediate fix, state that in the report and stop there.
- Never include secrets, credentials, tokens, API keys, customer records, or tax data in reports or chat. For sensitive findings, cite only the file, line, and identifier name; never include the value, even in snippets or audit output.
- Report only confirmed findings traced to real `file:line` locations opened and read in the checkout. An unverified search hit or speculative data flow is not a finding at any severity.
- A run with no findings is successful. Report zero counts and the actual coverage.

## Establish the checkout and coverage

Use the current date for the audit. Confirm the checkout is `accrual-dev/epsilon` on `main` and record the audited revision. Do not overwrite local changes to establish the checkout.

Epsilon is a pnpm monorepo. The browser app is expected under `apps/firm/app-srv`; shared UI ships from packages such as `packages/compound`. Server-rendered and email/PDF templates reachable from the browser are also in scope.

Confirm the actual layout using `pnpm-workspace.yaml` and the app structure before scanning. Do not assume a flat repository or that previous audit paths remain correct. Scope searches to browser-delivered source and relevant rendering paths, rather than treating all monorepo code as frontend code.

## Find candidates and trace their inputs

Use the following indicators as starting points, adapting paths and globs to the confirmed layout. Open each candidate, read the surrounding code, and trace the input to its source before classification.

### XSS and injection

Treat these as high-priority candidates, not automatically high-severity findings:

- React HTML injection:
  ```bash
  rg -n "dangerouslySetInnerHTML" apps/firm/app-srv packages -g "*.tsx" -g "*.jsx" -g "*.ts" -g "*.js"
  ```
- Direct DOM writes: `.innerHTML =`, `.outerHTML =`, `document.write`, and `insertAdjacentHTML`.
- URL-based injection: assignments to `location.href`, calls to `location.replace`, and `window.open`.
- Code execution: `eval(`, `new Function(`, and string-valued `setTimeout` or `setInterval`.
- Unescaped template output, including Twig `|raw` and `{% autoescape false %}`, wherever server-side or email/PDF templates are rendered.

### CSRF

- Find `<form` elements without CSRF tokens in TSX, JSX, HTML, and template files.
- Trace state-changing requests made through `fetch`, Axios, and application API-client wrappers, including POST, PUT, DELETE, and PATCH.
- Check the actual protection before calling a missing form token a vulnerability.

### Sensitive data exposure

- Inspect `localStorage` and `sessionStorage` usage for session, identity, tax, or customer data.
- Search for hardcoded secret indicators such as `api[_-]?key\s*[:=]`, `secret\s*[:=]`, `password\s*[:=]`, and `token\s*[:=]`.
- Verify whether a candidate is a real secret or sensitive value without reproducing it in output.

## Review framework risks

Check paths that text searches alone cannot establish:

- React escaping bypasses: raw HTML, ref callbacks writing HTML, user-controlled `href` or `src` values that can carry `javascript:` or `data:`, and unvalidated objects spread into DOM props.
- Route parameters, search parameters, and loader/action responses used in rendering or URL construction.
- Sanitizers: confirm every path into the sink is sanitized and that configuration does not permit scripts, event handlers, or `javascript:` URLs.
- DOM clobbering: named elements and `id`/`name` attributes that can shadow globals read by the app.
- Escaping defaults and explicit opt-outs in server-rendered and email/PDF templates.

Consult the applicable OWASP contracts directly:

- [XSS Prevention](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html)
- [DOM XSS](https://cheatsheetseries.owasp.org/cheatsheets/DOM_based_XSS_Prevention_Cheat_Sheet.html)
- [DOM Clobbering](https://cheatsheetseries.owasp.org/cheatsheets/DOM_Clobbering_Prevention_Cheat_Sheet.html)
- [HTML5 Security](https://cheatsheetseries.owasp.org/cheatsheets/HTML5_Security_Cheat_Sheet.html)

## Validate defensive measures

Validate defenses from available code and permitted non-production evidence; do not assume they exist.

- Locate response-header configuration and record the actual Content Security Policy. Flag `unsafe-inline`, `unsafe-eval`, wildcard sources, and missing or report-only policies on routes rendering user content.
- Check emitted `X-Content-Type-Options`, `Referrer-Policy`, `Strict-Transport-Security`, and frame-ancestor controls. Distinguish configured behavior from observed headers when runtime verification is unavailable.
- Identify and name the CSRF protection: tokens, SameSite cookies, or an authentication scheme immune to ambient credentials. Confirm applicability to the request flow. A state-changing endpoint without protection is a finding.
- Check whether input crossing into the frontend is schema-validated and identify validation that is client-only.
- Examine file uploads, error handling, and JWT/session storage where the frontend touches them.

Consult the relevant OWASP guidance:

- [Content Security Policy](https://cheatsheetseries.owasp.org/cheatsheets/Content_Security_Policy_Cheat_Sheet.html)
- [CSRF Prevention](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html)
- [Input Validation](https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html)
- [AJAX Security](https://cheatsheetseries.owasp.org/cheatsheets/AJAX_Security_Cheat_Sheet.html)
- [File Upload](https://cheatsheetseries.owasp.org/cheatsheets/File_Upload_Cheat_Sheet.html)
- [Error Handling](https://cheatsheetseries.owasp.org/cheatsheets/Error_Handling_Cheat_Sheet.html)
- [JWT](https://cheatsheetseries.owasp.org/cheatsheets/JSON_Web_Token_for_Java_Cheat_Sheet.html)
- [User Privacy Protection](https://cheatsheetseries.owasp.org/cheatsheets/User_Privacy_Protection_Cheat_Sheet.html)
- [gRPC Security](https://cheatsheetseries.owasp.org/cheatsheets/gRPC_Security_Cheat_Sheet.html)

## Audit dependencies

Run the repository's own audit path: `pnpm audit` or the audit command actually defined by the repository. Record the exact command and its real output. Do not use fix options or paraphrase an advisory you did not observe. Redact sensitive values if output contains them and identify the redaction.

For each advisory, resolve the dependent that brings it in and confirm that the affected dependent and code path ship in the browser app. Count only advisories affecting shipped frontend code. Put dev-only, build-only, and transitively unreachable advisories in a short “not applicable” list with reasons, outside severity counts. If reachability cannot be established, record the gap rather than inventing a conclusion.

References:

- [Node.js Security](https://cheatsheetseries.owasp.org/cheatsheets/Nodejs_Security_Cheat_Sheet.html)
- [NPM Security](https://cheatsheetseries.owasp.org/cheatsheets/NPM_Security_Cheat_Sheet.html)

## Assign severity from confirmed reachability

| Severity | Confirmed issue types |
| --- | --- |
| CRITICAL | Exploitable XSS, authentication bypass, secrets exposure |
| HIGH | Missing CSRF protection, unsafe DOM manipulation, injection vectors reaching a backend |
| MEDIUM | Weak CSP, missing security headers, improper input validation |
| LOW | Informational disclosure, deprecated functions, suboptimal practices |

For every finding, explicitly state whether the sink receives a user-controlled, reachable value or a developer-controlled static value. Severity follows reachability and impact. A build-time constant passed to `dangerouslySetInnerHTML` is not critical XSS; classify it LOW or exclude it and explain why. Do not report speculative vulnerabilities as low-severity findings.

## Compare with the previous report

Before writing, locate the prior week's “Epsilon Frontend Security Audit” report through AIM document discovery and read it with `read_document`. Deduplicate findings and mark them `new`, `unchanged`, or `resolved`.

List findings resolved since the prior report so the audit explains the change over time. Use current evidence to establish resolution; an area not inspected is not evidence that a finding was fixed. If no prior report exists, say so and mark all findings `new`. If prior-report access fails, disclose that comparison gap.

## Publish the report

Write Markdown using this structure:

```markdown
## Security Audit Report

### Summary — Critical: X, High: X, Medium: X, Low: X

### Critical Findings

#### [CRITICAL-001] Title
- Location: `file:line`
- Pattern: confirmed code snippet, excluding sensitive values
- Input source: user-controlled and reachable via <path>, or developer-controlled static value
- Status: new | unchanged | resolved
- Risk: what an attacker achieves
- Remediation: the concrete fix
- Reference: OWASP cheatsheet URL

### High Findings
### Medium Findings
### Low Findings

### Resolved Since Previous Report

### Dependency Advisories
Exact command run, raw result with any necessary sensitive-value redactions,
advisories affecting shipped frontend code, and not-applicable advisories with reasons.

### Coverage And Gaps
Audited revision, workspaces scanned, searches run, prior-report comparison,
and anything that could not be inspected or verified.
```

Use the same finding fields for each severity. Count current findings separately from resolved findings, and avoid double-counting dependency advisories. For zero findings, write the explicit count, such as `Critical: 0`, and plainly state that none were found at that severity. Do not pad empty sections.

Save the full report using `write_document`:

- `name`: `Epsilon Frontend Security Audit - <YYYY-MM-DD>`
- `mediaType`: `text/markdown`
- `intent`: a sentence identifying the weekly frontend security audit
- `content`: the full Markdown report

Reply in chat with a TL;DR only: per-severity counts, top findings with `file:line`, the new/unchanged/resolved split, and the returned document URL.
