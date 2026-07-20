# CONTEXT — append-only session log (todo-api)

> One entry per session, newest on top. Never edit old entries.

SESSION: 2026-03-14 (solo — CRUD build)
Closed T-07 and T-08. T-07 uncovered the raw-`db.run` error-swallowing bug (failed
INSERT returned 200) → fixed with the `q()` helper, logged as a war story. Found (but
did not fix) missing input validation → filed as T-11. Next: T-09 PATCH toggle.
APPCORE re-synced (added GET/:id and the 404 paths).

INIT: 2026-03-10
Project started. Target: a tiny REST todo API to learn the .agents/ workflow solo.
Stack: Node 20 + Express + better-sqlite3, Vitest. First objective: PH1 scaffold.
Mode chosen: Auditor/Executor (one agent) — small enough not to need two.
