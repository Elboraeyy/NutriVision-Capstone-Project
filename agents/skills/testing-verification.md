# Skill: Testing and Verification

## Use this skill when

Finishing any meaningful code change, adding a feature, changing state logic,
changing navigation, or modifying a shared widget.

## Test layers

Use the smallest test that proves the behavior, then add higher-level coverage
for critical journeys:

- **Unit:** entities, validators, mappers, use cases, repositories, API/AI
  adapters, and failure mapping.
- **Bloc/Cubit:** events/methods and resulting immutable states.
- **Widget:** rendering, interaction, loading/error/empty states, semantics,
  and route composition.
- **Integration:** important end-to-end journeys across real app wiring.
- **AI evaluation:** fixed input/output cases for quality, safety, schema
  validity, latency, and failure behavior.

The project-level checklist and stage templates live in [`../tests/README.md`](../tests/README.md).

## Required commands

Run these from the project root:

```bash
dart format .
flutter analyze
flutter test
```

## What to test

- Use cases through their public behavior.
- Repository success, failure, and empty results.
- Bloc events and resulting states.
- Cubit public methods and resulting states.
- Widget rendering for changed screens.
- Important route and auth/onboarding transitions.
- Shared widgets when their behavior or layout changes.

For every meaningful feature, create or update a test artifact under
`agents/tests/` before handoff. The artifact records scope, acceptance cases,
fixtures/fakes, negative paths, and the exact executable test files under
`test/` or `integration_test/`.

Avoid private implementation-detail tests. Assert what a user or caller can
observe.

## Completion checklist

- `dart format .` completed with no unexpected source changes.
- `flutter analyze` reports no issues.
- `flutter test` passes.
- `git diff --check` reports no whitespace errors.
- No generated files, build output, secrets, credentials, or personal IDE
  settings were added.
- Unrelated user changes are still present and untouched.
- Any intentional limitation is documented in the handoff.

## If a check fails

1. Read the first actionable error, not only the final summary.
2. Fix the smallest relevant cause.
3. Re-run the failed check.
4. Re-run all required checks before handoff.
5. Report unresolved failures honestly with the exact command and error.
