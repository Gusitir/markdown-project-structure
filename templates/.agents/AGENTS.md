# AGENTS.md — doctrine for <PROJECT NAME>

> The rules and roles. Changes rarely. State and tasks live in CURRENT.md, not here.

## Roles
- **Executor** (<model/tool>): writes code. One task, records evidence, STOPs.
- **Auditor** (<model/tool>): plans, writes task specs with acceptance criteria,
  and re-verifies every delivery itself before approving.

## Workflow
1. Read `CURRENT.md` → `APPCORE.md`. Nothing else.
2. Execute the task in "NEXT STEP".
3. Log 1–3 lines + evidence in `CURRENT.md`. STOP for audit.
   (Batch mode: N tasks in a row, one commit each, STOP at the end.)
4. Auditor: verdicts in `CURRENT.md` (PASS / PASS WITH FIX / FAIL); corrections
   become tasks in the milestone plan.

## State files
- `PLAN.md`: roadmap (PH1..N). `CURRENT.md`: live state. `APPCORE.md`: code map.
- `CONTEXT.md`: session dumps (append-only). `TESTING.md`: test matrix.
- `PLAN_<milestone>.md`: current cycle's task specs. `archive/`: closed plans.

## Hard rules (universal)
1. One task = one commit `[T-NN]`. Never mix tasks.
2. Evidence or it didn't happen — paste real command output.
3. Auditor re-runs the checks; never trusts the report. Audits COMMITS after STOP.
4. Strict scope. Out-of-scope → FINDINGS in CURRENT.md, no code.
5. Selective `git add`. Never `git add -A`.
6. Secrets: real `.env` gitignored; `.env.example` valueless; grep for keys after changes.
7. Root cause before fixing. Verify large files were read whole. Real checksums on releases.

## War stories (this project's hard-won rules — add as incidents happen)
- <incident → root cause → one-line rule>

## Environment notes
- OS / shell: <...>   Build/test quirks: <...>   Paths that bite: <...>
