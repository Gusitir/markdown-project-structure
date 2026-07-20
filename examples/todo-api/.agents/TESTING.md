# TEST MATRIX — todo-api v0.3.0

> Auditor builds it; owner marks [OK]/[FAIL]/[SKIP]; auditor triages fails into the plan.
> Fixes do NOT go here — they go to the milestone plan.

## A. HEALTH & BOOT
- [OK] A1. `node src/app.js` boots, `curl localhost:3000/health` → `{status:"ok"}`.
- [OK] A2. Fresh boot creates `todo.db` with the `todos` table (`initDb`).

## B. CRUD
- [OK] B1. `POST /todos {title}` → 201 + body has id, done:false.
- [FAIL: empty title accepted → 201, should be 400] B2. `POST /todos {title:""}`.
      → filed as T-11 (input validation).
- [OK] B3. `GET /todos/:id` valid → 200 row.
- [OK] B4. `GET /todos/999` → 404.
- [ ] B5. `PATCH /todos/:id` toggles done → 200 (blocked on T-09).
- [ ] B6. `DELETE /todos/:id` → 204; missing → 404 (blocked on T-10).

## C. DATA INTEGRITY (war-story guard)
- [OK] C1. A failing INSERT returns 500, NOT 200 (the T-07 regression guard).

---

## RESULTS
```
Date: 2026-03-14
OK: 6   FAILS: 1   SKIPS/BLOCKED: 2
FAIL B2: empty title accepted → task T-11 (validation).
```
