# AGENTS.md — doctrine for todo-api

> Rules and roles. Changes rarely. State and tasks live in CURRENT.md, not here.

## Roles — mode: AUDITOR / EXECUTOR (one agent, two hats)
Small solo project, so one strong model plans, executes, then audits its own commit
against the acceptance criteria before moving on. (Would promote to two-agent
Executor→Auditor if this became load-bearing.)

## Workflow
1. Read `CURRENT.md` → `APPCORE.md`. Nothing else.
2. Execute the task in "NEXT STEP".
3. Log 1–3 lines + evidence in `CURRENT.md`. Self-audit against criteria. STOP.

## State files
- `PLAN.md` roadmap · `CURRENT.md` live state · `APPCORE.md` code map
- `CONTEXT.md` session dumps (append-only) · `TESTING.md` matrix · `archive/` closed plans

## Hard rules (universal)
1. One task = one commit `[T-NN]`. Never mix tasks.
2. Evidence or it didn't happen — paste real command output (`npm test`, `curl`, grep).
3. Auditor re-runs the checks; never trusts the report. Audits COMMITS after STOP.
4. Strict scope. Out-of-scope → FINDINGS in CURRENT.md, no code.
5. Selective `git add`. Never `git add -A`.
6. Secrets: real `.env` gitignored; `.env.example` valueless; grep for keys after changes.
7. Root cause before fixing. Verify large files read whole. Real checksums on releases.

## War stories (this project's hard-won rules)
- **SQLite + async:** `db.run` is callback-based; wrapping it wrong swallowed errors and
  a failed INSERT returned 200. Rule: every DB call goes through the promisified helper
  in `db.js` — never raw `db.run` in a route. (Cost: a whole afternoon on T-07.)

## Environment notes
- Node 20 + Express + better-sqlite3. Tests: `npm test` (Vitest). DB file is gitignored.
- `PORT` from `.env` (default 3000). Never commit `todo.db`.
