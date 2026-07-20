# CURRENT STATE (compact; history lives in git + archive/)

Version: <x.y.z>. Repo: <public/private>. License: <...>.
Roles: <executor> executes; <auditor> plans/audits.
Active cycle plan: `.agents/PLAN_<milestone>.md`.

## NEXT STEP
1. <who>: <the one next action>
2. <who>: <...>

## AUDITS (this cycle)
- <T-NN> (<hash>): **PASS / PASS WITH FIX / FAIL** — <what was verified independently>.

## LOGBOOK (executor: 1–3 lines + evidence per closed task)
- [T-NN] <what changed>. Evidence: `<command>` → <result>.

## FINDINGS (out-of-scope; no code — auditor triages into the plan)
- <...>

## OWNER CHECKLIST (non-code, human actions)
- [ ] <...>

## ENVIRONMENT — permanent notes
- <truncation traps, WSL-only builds, path gotchas...>

<!-- GOLDEN RULE: compact this file on milestone close. If it passes ~5 KB or has two
     "NEXT STEP" sections, compact NOW — the history is already in git. -->
