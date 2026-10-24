# Skill: Architecture Audit and Repair

## Use this skill when

Reviewing another team member's code, inheriting an AI-generated change,
finding duplication, or repairing code that drifted from the architecture.

## Audit sequence

1. Read `AGENTS.md`, `ARCHITECTURE.md`, and the feature's test plan.
2. Inspect imports and dependency direction.
3. Search screens/widgets for direct repository, API, storage, or AI calls.
4. Search for duplicate widgets, validators, mappers, toasts, and state.
5. Check Bloc/Cubit choice and state immutability.
6. Check composition-root registration and route ownership.
7. Check loading, empty, failure, validation, offline, and unavailable paths.
8. Check responsive/accessibility behavior and visual consistency.
9. Check secrets, logs, dependencies, generated files, and personal settings.
10. Run tests and document findings by priority.

## Repair policy

- Fix clear violations in the smallest safe slice.
- Extract repeated behavior into the nearest correct reusable layer.
- Move business decisions from widgets into use cases/domain code.
- Move external access behind data repositories.
- Replace duplicate state with the existing source of truth.
- Add a regression test before or with the repair.
- Preserve behavior unless the violation itself is the bug.
- If a broad refactor is required, split it into an approved migration plan.

## Review result format

```text
Finding: <problem>
Priority: P0/P1/P2/P3
Location: <file and line>
Risk: <what can break>
Repair: <smallest safe fix>
Test: <regression test or test plan>
```
