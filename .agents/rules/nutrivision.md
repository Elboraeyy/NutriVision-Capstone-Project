# NutriVision Antigravity Workspace Rule

Read the root [`AGENTS.md`](../../AGENTS.md) before making any change. It is
the canonical source of truth for this repository and applies to Codex,
Antigravity, and every other coding agent.

For the project workflow, read [`ARCHITECTURE.md`](../../ARCHITECTURE.md) and
the relevant resource under [`agents/`](../../agents/README.md). Use the
discovery → plan → design → build → test → audit → handoff lifecycle.

Follow the feature-first Clean Architecture, keep domain code independent of
Flutter and external services, register dependencies in `lib/app/app.dart`,
centralize routes, reuse existing widgets/tokens, and add the appropriate
stage test artifact under `agents/tests/`.

Before handoff, run `dart format .`, `flutter analyze`, `flutter test`, and the
relevant integration or AI evaluation tests. Repair clear architecture drift,
duplication, insecure client-side secrets, or missing failure/empty/loading
paths in the smallest safe slice and add regression coverage.

Do not create conflicting rules here. Update `AGENTS.md` when a repository-wide
rule changes.
