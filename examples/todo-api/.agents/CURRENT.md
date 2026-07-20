# CURRENT STATE (todo-api — compact; history in git + archive/)

Version: 0.3.0. Repo: private. License: MIT. Mode: Auditor/Executor (one agent).
Active cycle plan: `.agents/PLAN_v0.3-crud.md`.

## NEXT STEP
1. EXECUTOR: T-09 — add `PATCH /todos/:id` (toggle `done`). Criteria: returns 200 +
   updated row; 404 on missing id; `npm test` green; no raw `db.run` (war story).

## AUDITS (this cycle)
- T-07 (a1b2c3d): **PASS WITH FIX** — CRUD create worked but a failed INSERT returned
  200 (raw `db.run` swallowed the error). Fixed via promisified helper; re-ran
  `npm test` → 12 passing. Root cause logged as a war story in AGENTS.md.
- T-08 (e4f5a6b): **PASS** — `GET /todos/:id` + 404 path. Verified independently:
  `curl -s localhost:3000/todos/999 -o /dev/null -w "%{http_code}"` → 404.

## LOGBOOK
- [T-08] GET /todos/:id with 404. Evidence: `npm test` → 12 passing; curl 999 → 404.
- [T-07] POST /todos + list. Evidence: `npm test` → 12 passing (after the fix above).

## FINDINGS (out-of-scope; auditor triages into the plan)
- No input validation on POST body (empty title accepted). → candidate task for PH2 close.

## OWNER CHECKLIST
- [ ] Decide auth strategy for PH3 (JWT vs session) before T-12.

## ENVIRONMENT — permanent notes
- `better-sqlite3` is synchronous; do NOT `await` it. The war-story helper wraps errors,
  not async. Vitest resets the DB per file via `beforeEach`.

<!-- GOLDEN RULE: compact on milestone close; if this passes ~5 KB, compact NOW. -->
