# Contributing to NutriVision

Thank you for contributing to the NutriVision capstone project. This document describes the initial collaboration rules for the team. It can be expanded as the project workflow becomes more specific.

Before making code changes, read the root [`AGENTS.md`](AGENTS.md). It is the
canonical guide for the current Clean Architecture, Bloc/Cubit policy,
dependency injection, UI conventions, and verification requirements.

## Architecture

Organize new functionality by feature using `data`, `domain`, and
`presentation` layers. Keep repository contracts and use cases in `domain`,
concrete implementations in `data`, and screens/widgets/state managers in
`presentation`.

Use a real `Bloc<Event, State>` for shared or asynchronous feature workflows.
Use Cubit only for small local UI state. Register repositories through
`MultiRepositoryProvider` in `lib/app/app.dart`; screens must not construct
repositories or call them directly.

## Branches

Create a focused branch from the latest shared branch. Use one of these prefixes:

- `feature/` for a new feature.
- `fix/` for a bug fix.
- `docs/` for documentation-only changes.
- `test/` for test-only changes.
- `chore/` for setup and maintenance work.

Example: `feature/meal-history-ui`

Avoid working directly on `main`. Keep each branch focused and delete it after its pull request is merged when appropriate.

## Commits

- Write short, specific commit messages in the imperative mood.
- Keep unrelated changes in separate commits.
- Do not commit secrets, generated build output, signing files, or personal IDE settings.

Examples:

```text
feat: add meal history screen
fix: handle empty nutrition response
docs: update Firebase setup notes
```

## Pull Requests

Before opening a pull request:

- Rebase or merge the latest shared branch as agreed by the team.
- Run `dart format .`.
- Run `flutter analyze`.
- Run `flutter test`.
- Confirm that no secrets or unrelated files are included.
- Add screenshots or testing notes when the change affects the UI or user flow.

Each pull request should explain what changed, why it changed, and how it was tested. At least one teammate should review it before merging.

## Team Workflow

1. Discuss the task and acceptance criteria before implementation.
2. Create a focused branch using the naming rules above.
3. Implement and test the change locally.
4. Open a pull request and request review from the team.
5. Resolve review comments and merge only after the checks pass.

## Security

Never add API keys, Firebase Admin credentials, private certificates, passwords, signing keys, or user data to Git. If a secret is committed accidentally, notify the team lead immediately so it can be revoked and rotated; removing it from a later commit is not enough.
