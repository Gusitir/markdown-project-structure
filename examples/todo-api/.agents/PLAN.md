# todo-api — Development Plan

## DONE
- [x] PH1: Scaffold — Express app, `db.js` (better-sqlite3 + promisified helper),
      `/health`, Vitest wired. Tag v0.1.0.

## IN PROGRESS
# PH2: CRUD (detail: .agents/PLAN_v0.3-crud.md)
- [x] T-07 POST /todos + GET /todos
- [x] T-08 GET /todos/:id (+404)
- [ ] T-09 PATCH /todos/:id (toggle done)
- [ ] T-10 DELETE /todos/:id (+404)
- [ ] T-11 Input validation (empty title → 400) — from CURRENT.md FINDINGS

## ROADMAP (approved, not scheduled)
# PH3: Auth [v0.4]
- [ ] API-key or JWT gate on write routes (owner decides — see CHECKLIST)
- [ ] Per-user todo scoping

# PH4: Deploy [v1.0]
- [ ] Dockerfile + CI (test on push) + release checklist

## NOTES / MANUAL ACTIONS
- Owner picks the auth model before PH3 starts (blocks T-12).
