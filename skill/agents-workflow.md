# agents-workflow — durable project memory for AI coding agents

A battle-tested workflow for building software with AI agents where **the project's
state lives in versioned Markdown files, never in the chat window**. One agent (or
person) *executes*, another *audits*, and a small set of `.agents/*.md` files carry
the context across sessions, model switches, and even different tools.

Born on a real product (a Linux HTPC remote-control app taken from v1.0 to v1.7.7:
30+ audited tasks, multiple releases, three systemic bugs killed) where chat context
kept ballooning and getting summarized away. The fix: **files are memory.**

---

## The core idea

Chat history is volatile and expensive. So don't store project state there. Store it
in files that:

- **travel with the repo** (git is the source of truth and the history),
- are **read at the start of every session** (a fresh chat catches up in ~2 files),
- are **compacted, not appended forever** (the log lives in git, not in the live file).

Any agent that can read/write files and run shell commands can pick up exactly where
the last one left off — including a brand-new chat, a different model, or a different
tool.

## The two roles

- **Executor** — writes code. Does one task, records evidence, stops.
- **Auditor** — plans, writes task specs with acceptance criteria, and **verifies each
  delivery by re-running the checks itself** before approving.

The separation is what keeps quality high: **the auditor never trusts the executor's
report** — it re-runs the checks and audits the commit, not the working tree.

**Orchestration is the user's choice, per project — the files and rules stay identical:**

- **Executor → Auditor (two agents):** a fast/cheap model executes; a stronger model
  audits in a *separate* chat that sees only the output. Best for high-stakes or
  long-lived code — a genuinely independent second pair of eyes.
- **Auditor / Executor (one agent, two hats):** the same agent plans, executes, then
  audits its own commit against the criteria. Best for small or fast-moving projects.
- **Human auditor:** an agent executes; the user audits and gives the GO. Best for
  sensitive code.

Ask the user which mode they want (or infer from project risk) and record it in
`AGENTS.md`, so a fresh session knows how the work is orchestrated. The mode can change
mid-project (start solo, promote to two-agent once the code is load-bearing).

---

## On invocation (bootstrapping a project)

1. Ask the user for whatever you don't know: project description, goal, tentative
   stack, and who plays executor / auditor.
2. Create the `.agents/` folder at the repo root, filled in with what you know
   (personalized — not empty templates).
3. Recommend committing `.agents/` — the checkpoint must travel with the repo.

## The `.agents/` structure

```
.agents/
├── AGENTS.md      # doctrine: roles, workflow, the hard rules
├── CURRENT.md     # live state: what happened, audits, NEXT STEP, logbook
├── PLAN.md        # roadmap by phases (PH1..N) with checkboxes
├── APPCORE.md     # code index: what lives where (endpoints, files, protocols)
├── CONTEXT.md     # append-only session dumps for context recovery
├── TESTING.md     # test matrix by area with [OK]/[FAIL]/[SKIP] results
└── archive/       # closed-milestone plans and superseded reports
```

## The file contract (who writes, when, what does NOT go here)

This table is the thing that keeps the files from degenerating. Copy it into the
project's `.agents/AGENTS.md`.

| File | Who / when writes | What goes in | What does NOT (and where it goes) |
|---|---|---|---|
| `AGENTS.md` | Auditor; rarely (rule/role/model change) | Doctrine and hard rules | State or tasks (CURRENT); history (git) |
| `PLAN.md` | Auditor; when planning and closing milestones | Phases PH-N with checkboxes; approved roadmap | Task specs (milestone plan); logbook (CURRENT); unapproved ideas |
| `PLAN_<milestone>.md` | Auditor; when triaging/planning a cycle | Tasks `[T-NN]` with ROOT CAUSE + fix + acceptance criteria; the cycle's audit verdicts | Live state (CURRENT). On close → `archive/` |
| `CURRENT.md` | Everyone. Executor: logbook + findings on each task close. Auditor: verdicts + NEXT STEP | Live state: current version, what's next, this cycle's audits, logbook with evidence, findings, owner checklist | Specs (plan), doctrine (AGENTS), code map (APPCORE), dumps (CONTEXT). GOLDEN RULE: **compact on milestone close** — the history already lives in git |
| `APPCORE.md` | Whoever adds components; auditor via `reindex` after releases | The map: what lives where, 1–3 lines per entry, endpoints + gates, protocols | Code, tutorials, state, history. If it wasn't verified with grep, it doesn't get written |
| `CONTEXT.md` | Auditor; when CLOSING each session | Append-only session summary (decisions, where everything stands) | Never edit old entries; nothing operational/day-to-day |
| `TESTING.md` | Auditor builds the matrix; owner marks `[OK]/[FAIL]/[SKIP]`; auditor triages | Actionable items (command + expected) for the current cycle; RESULTS with failure→task mapping | The fixes (those go to the milestone plan). Old matrix → renewed per cycle |
| `archive/` | Auditor; on milestone close | CLOSED plans and reports | Nothing gets resurrected: reference only |

## The lifecycle rhythm

- **Session start:** read `CURRENT.md` → `APPCORE.md`. Nothing else.
- **During a task:** don't write docs (focus on code).
- **On task close:** 1–3 lines + evidence in `CURRENT.md`'s logbook.
- **On audit:** verdicts in `CURRENT.md` + corrections as tasks in the milestone plan.
- **On milestone close:** check the box in `PLAN.md`, move the milestone plan to
  `archive/`, **compact `CURRENT.md`** (3–5 line cycle summary), append an entry to
  `CONTEXT.md`, run `reindex` on `APPCORE.md`.
- **Degeneration signal:** if `CURRENT.md` grows past ~5 KB or has two "NEXT STEP"
  sections, compact it NOW.

---

## The hard rules (universal — copy these verbatim into `AGENTS.md`)

These apply to any project. Every one of them was written after an incident where its
absence cost real time.

1. **One task = one commit** with a `[T-NN]` prefix. Never mix tasks in one commit.
2. **Evidence or it didn't happen.** Every acceptance criterion is proven with the
   **real command output pasted into the logbook** (lint / compile / grep / test).
   Reporting "verified" without running the command is the worst offense in the system.
3. **The auditor does NOT trust the report.** It re-runs greps / compiles / downloads
   itself before approving. Verdicts: `PASS` / `PASS WITH FIX` / `FAIL`.
4. **Strict scope.** Nothing outside the task. Out-of-scope findings go to a FINDINGS
   section in `CURRENT.md`, with no code.
5. **Selective `git add`** of the task's files only. Never `git add -A` (it sweeps up
   unrelated workspace changes).
6. **Secrets.** The real `.env` is always gitignored; `.env.example` carries no values;
   the auditor greps for key patterns after any change.
7. **The auditor audits COMMITS, not the working tree** (`git show HEAD:<file>`), and
   **only after the executor's explicit STOP.** Reading the tree mid-edit produces
   false `FAIL`s from transient states (a half-corrected draft once nearly spawned a
   phantom task).
8. **Root cause before fixing.** Test failures are triaged to a confirmed root cause in
   the code before any task is created. Never patch symptoms.
9. **Large files:** verify the tool read the *whole* file (`wc -l` vs what you see)
   before editing — silent truncation corrupts edits.
10. **Releases / artifacts:** verify **real** checksums live (download the published
    artifact, hash it, compare to the manifest) — computed by the executor AND repeated
    by the auditor before the GO. Never invent a hash.

## War stories (project-specific rules are born from incidents — add your own)

The rules above are universal. But every project accumulates its own, and the best way
to teach an agent is with the scar that produced the rule. Keep a short list in your
`AGENTS.md`. Examples from the origin project, purely illustrative — replace with yours:

- *Self-updating a systemd service:* the updater must re-exec into a transient unit
  (`systemd-run`) so the service stop doesn't kill the update mid-`dpkg`. (Cost: two
  broken releases before the cause — the updater living in the service's own cgroup —
  was found.)
- *Debian package `prerm`:* distinguish `upgrade` from `remove` (`$1`) — only disable
  the service on `remove`, or upgrades leave it dead.
- *iOS `MediaRecorder`:* Safari doesn't support `audio/webm`; detect the supported mime
  or the recording fails silently with zero bytes reaching the backend.
- *Service worker cache:* version the cache name at build time, or installed PWAs keep
  stale assets forever.

The pattern: **an incident → a confirmed root cause → a one-line rule in `AGENTS.md`.**
Over a project's life this list becomes the most valuable file in the repo.

---

## The `reindex` protocol (keeping `APPCORE.md` honest)

`APPCORE.md` is a curated map that saves thousands of tokens of searching — *but only
if it tells the truth*. An index that lies is worse than none (the agent edits blind).

After every release, or whenever the index misleads you:

1. Verify against the **real repo** (grep endpoints / routes / protocols / critical
   files), not from memory.
2. Fix stale entries, add what's new, delete what's dead.
3. **Never write anything you didn't verify with grep or a read.**
4. Note in `CURRENT.md`: "APPCORE re-synced `<date>` (N changes)".

Entries are short (1–3 lines each). `APPCORE.md` is a map, not documentation.
