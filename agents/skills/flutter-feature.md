# Skill: Build a Flutter Feature

## Use this skill when

Adding a new route-level feature or expanding an existing feature with domain
behavior, data access, state management, screens, or reusable widgets.

## Non-negotiable rules

- Use `lib/features/<feature>/data`, `domain`, and `presentation`.
- Put entities and repository contracts in `domain/`.
- Put concrete repositories in `data/`.
- Put one meaningful business action in each use case.
- Keep screens thin and keep feature widgets in `presentation/widgets/`.
- Register repositories, use cases, and state managers in `lib/app/app.dart`.
- Add routes through `lib/app/router/app_router.dart`.
- Do not call a repository directly from a screen or widget.
- Do not add a backend merely as an example.

## Workflow

1. Inspect similar existing features, especially `auth`, `home`, and
   `onboarding`.
2. Define the entity and repository contract first.
3. Add the use case(s) required by the user story.
4. Implement an in-memory repository unless a real backend is explicitly
   requested.
5. Choose Bloc or Cubit using `state-management.md`.
6. Add immutable states and events/methods for loading, success, and failure.
7. Register dependencies in the composition root.
8. Add the screen, widgets, and named route.
9. Add tests for use cases/repositories and state transitions.
10. Run the verification commands.

## Feature skeleton

```text
lib/features/<feature>/
  data/repositories/<concrete>_repository.dart
  domain/entities/<entity>.dart
  domain/repositories/<feature>_repository.dart
  domain/usecases/<action>.dart
  presentation/bloc/<feature>_bloc.dart
  presentation/screens/<feature>_screen.dart
  presentation/widgets/<feature>_widgets.dart
```

Only create directories that the feature actually needs. A simple static
screen does not need a repository or Bloc.

## Common mistakes

- Putting API calls in `build()` or a widget callback.
- Creating a repository with `new` inside a screen.
- Making every boolean a global Cubit.
- Duplicating a shared profile/session/onboarding model locally.
- Adding a large screen file instead of extracting feature widgets.
