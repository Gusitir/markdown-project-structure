# TEST MATRIX — <version>

> Auditor builds the matrix; owner marks [OK]/[FAIL]/[SKIP]; auditor triages fails
> into the milestone plan. Renewed per cycle. Fixes do NOT go here — they go to the plan.

Format per item: `[ ] <ID>. <action> → <expected result>`
Mark: `[OK]` / `[FAIL: what happened]` / `[SKIP: reason]`.

## A. <AREA e.g. INSTALL>
- [ ] A1. <command / action> → <expected>
- [ ] A2. <...>

## B. <AREA e.g. SECURITY / AUTH>
- [ ] B1. <...>

## C. <AREA e.g. CORE FLOW>
- [ ] C1. <...>

<!-- add areas relevant to the project: UI, resilience, uninstall, OTA, stress... -->

---

## RESULTS (owner fills; auditor triages)
```
Date:
OK:   /   FAILS:   SKIPS:
FAIL <ID>: <exact description + how to reproduce> → task <T-NN>
```
