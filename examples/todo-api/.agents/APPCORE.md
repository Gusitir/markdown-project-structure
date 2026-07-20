# APPCORE — code map (re-synced 2026-03-14, base v0.3.0)

> What lives where. 1–3 lines per entry. A map, not documentation.
> If it wasn't verified with grep/read, it doesn't get written here.

# DIRECTORIES
- /src/: app code. /test/: Vitest specs (one per route file). /: config + entry.

# ENDPOINTS (src/routes/todos.js unless noted; no auth yet — PH3)
- GET  /health (src/app.js) → {status:"ok"}
- GET  /todos            → 200 list
- POST /todos            → 201 {id,title,done:false}  (validation pending T-11)
- GET  /todos/:id        → 200 row | 404
- PATCH /todos/:id       → (T-09, in progress) toggle done
- DELETE /todos/:id      → (T-10, pending)

# CRITICAL FILES
- src/app.js: Express setup, mounts /todos, /health, error middleware (maps thrown
  {status,msg} → JSON). Entry: `node src/app.js`.
- src/db.js: better-sqlite3 handle + `q()` helper (the ONLY way to touch the DB —
  war story T-07). Schema in `initDb()` runs on boot.
- src/routes/todos.js: the CRUD handlers. All go through `q()`.
- test/todos.test.js: 12 specs. `beforeEach` wipes + reseeds the DB.

# EXTERNAL / DEPLOY
- None yet. PH4 adds Dockerfile + CI. DB is a local file `todo.db` (gitignored).

<!-- reindex: after each release/milestone, grep routes + files, fix stale, note in CURRENT. -->
