# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

_Pending improvements land here before the next tagged release._

### Ideas
- Additional worked examples (a larger, multi-milestone project).
- More universal war-story examples in the skill (beyond the origin project's).
- An optional, separate automation runner that drives the executor → auditor loop
  without hand-copying between chats (kept out of the portable skill on purpose).

## [1.0.0] - 2026-07-20

Initial public release: durable, cross-agent project memory for AI coding agents.
Keep a project's state in versioned `.agents/*.md` files so any agent — new chat,
different model, or different tool — resumes exactly where the last one left off.

### Added
- **Canonical skill** (`skill/agents-workflow.md`): the executor/auditor methodology,
  the `.agents/` file contract (who writes what, when, and what must not go where), the
  universal hard rules, the war-story pattern, token discipline, and the `reindex`
  protocol for keeping the code map honest.
- **Cross-agent installers** (`install.sh`, `install.ps1`) for Claude Code, Cursor,
  OpenCode, and the generic [`AGENTS.md`](https://agents.md) standard, with idempotent
  in-place updates for the marker-based targets.
- **Generic copy/paste install** (`curl` / `Invoke-WebRequest`) that works in any agent
  with no clone or tooling.
- **Starter templates** for the six `.agents/` files (`templates/.agents/`).
- **Worked example** (`examples/todo-api/`): a real mid-project `.agents/` folder with a
  walkthrough of the find → root-cause → rule loop.
- **Optional enforcement hook** (`hooks/pre-commit`): blocks committed secrets and real
  `.env` files, and warns when `CURRENT.md` bloats past the compaction threshold.
- **Executor/auditor orchestration modes** documented (two agents, one agent with two
  hats, or a human auditor) — chosen per project and recorded in `AGENTS.md`.
- **Mermaid state-machine diagram** of the session loop in the README.
- **Guidance** on when to use the workflow (and when it's overkill) and how it coexists
  with a tool's native memory.
- **MIT license** and a `.gitattributes` that enforces LF on shell scripts so they run
  on Linux/macOS regardless of the cloner's OS.

[Unreleased]: https://github.com/Gusitir/markdown-project-structure/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/Gusitir/markdown-project-structure/releases/tag/v1.0.0
