# Agent Task Template: Architecture Audit and Repair

```text
Read AGENTS.md, ARCHITECTURE.md, agents/skills/architecture-audit-refactor.md,
and agents/tests/stages/02-architecture-test.md.

Audit scope: <feature, branch, commit, or files>
Expected behavior: <user story or acceptance criteria>

Inspect:
- dependency direction and imports;
- direct API/storage/AI access from presentation;
- Bloc versus Cubit ownership and duplicate state;
- app.dart registration and centralized routes;
- repeated widgets, validators, mappers, and toasts;
- loading/error/empty/offline/security/accessibility paths;
- tests, generated files, secrets, and unrelated changes.

For each finding report priority, file/line, risk, repair, and test. Repair
clear violations in the smallest safe slice, add regression coverage, and run
the full verification suite.
```
