# NutriVision Agent Test Artifacts

This folder contains planning and audit artifacts for the tests that agents
must create while building the application. These Markdown files do not replace
executable Dart tests; they tell the agent what must be proven and where the
real tests belong.

## Mandatory rule

Every meaningful feature or integration must have:

1. A test plan copied from the relevant stage template in `stages/`.
2. Executable unit, Bloc/Cubit, widget, integration, or AI evaluation tests in
   the repository's `test/` or `integration_test/` directories as applicable.
3. A completed quality-gate review before handoff.

Use a feature-specific file such as:

```text
agents/tests/features/meal_history.md
```

The agent should create the `features/` directory only when the first feature
test plan is needed. Do not put executable Dart tests in this folder.

## Stage templates

| Stage | Template | Main proof |
| --- | --- | --- |
| Discovery | [`stages/01-discovery-test.md`](stages/01-discovery-test.md) | Acceptance criteria are testable. |
| Architecture | [`stages/02-architecture-test.md`](stages/02-architecture-test.md) | Dependencies and ownership are correct. |
| UI | [`stages/03-ui-test.md`](stages/03-ui-test.md) | Rendering, interaction, responsive behavior, and semantics. |
| Data/API | [`stages/04-data-api-test.md`](stages/04-data-api-test.md) | Mapping, errors, retries, cache, and contracts. |
| AI | [`stages/05-ai-test.md`](stages/05-ai-test.md) | Schema, safety, quality, fallback, and evaluation cases. |
| Integration | [`stages/06-integration-test.md`](stages/06-integration-test.md) | Critical user journeys through app wiring. |
| Release | [`stages/07-release-test.md`](stages/07-release-test.md) | CI, configuration, privacy, and release readiness. |
| Architecture scaffold | [`stages/08-architecture-scaffold.md`](stages/08-architecture-scaffold.md) | Folder ownership and handoff readiness. |

## Test naming and location

Prefer paths that mirror the production feature:

```text
test/features/<feature>/domain/<use_case>_test.dart
test/features/<feature>/data/<repository>_test.dart
test/features/<feature>/presentation/<bloc>_test.dart
test/features/<feature>/presentation/<screen>_test.dart
integration_test/<journey>_test.dart
```

Use fakes with clear inputs and outputs. Mock only at a boundary where a fake
would be impractical. Keep test data synthetic and free of personal data.
