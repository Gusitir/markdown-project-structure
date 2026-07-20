# agents-workflow

**Durable project memory for AI coding agents.** A workflow where your project's
state lives in a handful of versioned Markdown files — not in the chat window — so any
agent (Claude Code, Cursor, OpenCode, …) can pick up exactly where the last session,
model, or tool left off.

Portable, tool-agnostic, and battle-tested on a real product taken from v1.0 to v1.7.7
(30+ audited tasks, multiple releases, three systemic bugs found and killed) where the
chat kept ballooning and getting summarized away. The fix was simple: **files are
memory.**

---

## The problem it solves

- Chat context grows, gets truncated/summarized, and you lose the thread.
- Switching model or tool means starting cold.
- "I already told you that" — but the agent doesn't remember, because memory lived in
  the conversation.

## The idea in one line

Keep project state in `.agents/*.md` files that travel with the repo, get read at the
start of every session, and are **compacted, not appended forever** (git holds the
history). Add an **executor / auditor** split so quality doesn't depend on trust.

```
.agents/
├── AGENTS.md    # doctrine: roles + the hard rules
├── CURRENT.md   # live state: what happened, audits, NEXT STEP
├── PLAN.md      # roadmap by phases
├── APPCORE.md   # code map: what lives where
├── CONTEXT.md   # append-only session log
├── TESTING.md   # test matrix with results
└── archive/     # closed milestone plans
```

A fresh chat catches up by reading two files: `CURRENT.md` → `APPCORE.md`.

---

## Install

### Quick (script)

```bash
# from a clone of this repo
./install.sh --agent claude --global        # Linux/macOS
```
```powershell
.\install.ps1 -Agent claude -Global         # Windows
```

`--agent` (`-Agent`) is one of `claude` · `cursor` · `opencode` · `generic`.
Use `--global` for a home-level install (available in every project) or
`--project DIR` (default `.`) for a single project.

### Manual (copy the file yourself)

The skill body is [`skill/agents-workflow.md`](skill/agents-workflow.md). Place it where
your agent looks, with the frontmatter shown:

| Agent | Location | Frontmatter to prepend |
|---|---|---|
| **Claude Code** | `~/.claude/skills/agents-workflow/SKILL.md` (global) or `<proj>/.claude/skills/…` | `---`<br>`name: agents-workflow`<br>`description: <see below>`<br>`---` |
| **Cursor** | `<proj>/.cursor/rules/agents-workflow.mdc` | `---`<br>`description: <see below>`<br>`globs:`<br>`alwaysApply: false`<br>`---` |
| **OpenCode** | `<proj>/AGENTS.md` or `~/.config/opencode/AGENTS.md` | none (plain section) |
| **Generic** ([AGENTS.md](https://agents.md) standard) | `<proj>/AGENTS.md` | none (plain section) |

Description string for the frontmatter:

> Bootstrap and maintain the .agents/ Markdown project-memory workflow (executor/auditor
> roles, files as durable state). Use when starting a new project with this system, when
> asked to set up .agents/, or to plan / audit / compact project state.

For OpenCode / generic AGENTS.md, the installer wraps the content in
`<!-- BEGIN agents-workflow -->` … `<!-- END agents-workflow -->` markers so re-running
it updates in place instead of duplicating.

---

## Use it

Once installed, tell your agent:

> "Set up the `.agents/` structure for this project — here's the plan: …"

It will create the folder from the [templates](templates/.agents), personalized to your
project, and from then on maintain state there. Bootstrap templates you can also copy by
hand live in [`templates/.agents/`](templates/.agents).

---

## What makes it work (the non-obvious parts)

- **The auditor never trusts the report.** Every acceptance criterion is proven with
  real command output; the auditor re-runs the checks itself and audits *commits*, not
  the working tree.
- **Compaction over accumulation.** `CURRENT.md` is trimmed on every milestone close —
  the history is already in git. A file that grows forever stops being read.
- **`APPCORE.md` is a verified map**, not documentation. Kept honest by a `reindex`
  pass that greps the real repo. An index that lies is worse than none.
- **War stories become rules.** Every incident → confirmed root cause → a one-line rule
  in `AGENTS.md`. Over time this becomes the most valuable file in the repo.

Full methodology, the file contract (who writes what, when, and what must *not* go in
each file), and the hard rules: [`skill/agents-workflow.md`](skill/agents-workflow.md).

---

## Repo layout

```
skill/agents-workflow.md   # the canonical skill (single source of truth)
templates/.agents/         # starter files the workflow creates
install.sh · install.ps1   # per-agent installers
```

## License

MIT — see [LICENSE](LICENSE). Use it, fork it, adapt the rules to your own scars.
