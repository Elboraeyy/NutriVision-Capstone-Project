# Agent Task Template: Bug Fix

Copy this prompt when assigning a bug investigation:

```text
Read AGENTS.md, ARCHITECTURE.md, and agents/skills/testing-verification.md
before editing. Investigate and fix this bug:

Symptom: <what is wrong>
Reproduction: <steps or test>
Expected behavior: <what should happen>
Actual behavior: <what happens>

Requirements:
- Inspect the existing implementation and tests before changing code.
- Identify the root cause before implementing the fix.
- Make the smallest focused change.
- Preserve existing visual language and unrelated user changes.
- Add or update a regression test.
- Run dart format ., flutter analyze, and flutter test.

Report the root cause, changed files, verification results, and limitations.
```
