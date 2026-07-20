# Examples

A real `.agents/` folder mid-flight, so you can see the method instead of just reading
about it. People copy patterns, not prose.

## [`todo-api/`](todo-api/.agents) — a tiny REST API, caught mid-project

A solo project (mode: **Auditor/Executor**, one agent) at **v0.3.0**: the scaffold is
done, CRUD is in progress, and one bug found during testing has already flowed through
the whole loop. Read the files in this order — it's the same order a fresh chat would:

1. **[`CURRENT.md`](todo-api/.agents/CURRENT.md)** — where things stand *right now*:
   the NEXT STEP, two audit verdicts (one `PASS`, one `PASS WITH FIX`), the logbook with
   evidence, an out-of-scope finding, and an owner decision that's blocking future work.
2. **[`APPCORE.md`](todo-api/.agents/APPCORE.md)** — the code map: every route with its
   status, the critical files in 1–3 lines each. A fresh agent knows the shape of the
   codebase without opening a single source file.
3. **[`AGENTS.md`](todo-api/.agents/AGENTS.md)** — the doctrine: chosen mode, the hard
   rules, and a **war story** (a real bug that became a one-line rule).
4. **[`PLAN.md`](todo-api/.agents/PLAN.md)** — phases: done, in progress, roadmap.
5. **[`TESTING.md`](todo-api/.agents/TESTING.md)** — the matrix with a `FAIL` that got
   triaged into a task (`T-11`).
6. **[`CONTEXT.md`](todo-api/.agents/CONTEXT.md)** — the append-only session log.

### The loop this example shows

Follow the bug: testing finds an empty-title accepted (`TESTING.md` B2 `FAIL`) → it's
triaged as a task in `PLAN.md` (`T-11`) and noted in `CURRENT.md` FINDINGS. Separately,
`T-07`'s audit caught a failed INSERT returning `200` — the auditor **re-ran the test**,
found the root cause (raw `db.run` swallowing errors), fixed it, and the scar became a
**war story** in `AGENTS.md` so it never happens again. That full cycle —
find → root-cause → rule — is the whole point.

### Try it yourself

Point any agent at this folder and ask: *"Read the .agents/ files and tell me the exact
next step and why."* A well-behaved agent will answer **T-09 (PATCH toggle)**, cite the
acceptance criteria, and mention the `no raw db.run` rule — without you explaining a
thing. That's a project resuming itself.
