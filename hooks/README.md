# Hooks (optional enforcement)

The workflow's rules only work if they're followed. This pre-commit hook enforces the
two that are most costly to forget — so they hold even when nobody's watching.

- **Blocks secrets** — refuses to commit a real `.env` or staged content matching common
  secret shapes (private keys, `AKIA…`, `sk-…`, `ghp_…`, `xox…`, etc.). *Rule 6.*
- **Warns on bloat** — flags a staged `.agents/CURRENT.md` over ~5 KB: the compaction
  signal. It warns, never blocks.

## Install (per repo)

```sh
cp hooks/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

Or, to version it with the repo and share it with your team:

```sh
git config core.hooksPath hooks    # git runs hooks/ directly (Git 2.9+)
```

**Windows:** the hook is POSIX `sh`; it runs under Git Bash / WSL (both ship with Git
for Windows). No PowerShell port needed — git invokes it through its bundled shell.

**Bypass** a specific commit intentionally (e.g. committing a documented test fixture):

```sh
git commit --no-verify
```

The secret patterns are deliberately conservative (few false positives). Add your own
provider's key format to the `patterns` list in the hook as your stack grows — another
war story that becomes a one-line rule.
