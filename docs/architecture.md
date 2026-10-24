# NutriVision Architecture

This project uses a feature-first Flutter structure with `flutter_bloc`.

## Feature structure

Each feature owns its presentation, business logic, and data code:

```text
lib/features/<feature>/
  data/            # datasources, models, repository implementations
  domain/          # entities, repository contracts, use cases
  presentation/    # blocs/cubits, screens, feature widgets
```

The dependency direction is:

```text
Screen/Widget -> Bloc or Cubit -> Use Case -> Repository -> Data Source
```

Presentation code must not call Firebase, Dio, or an AI provider directly.
Repository interfaces belong to the domain layer; implementations and DTO
mapping belong to the data layer.

## Bloc or Cubit?

- Use **Cubit** for local direct state such as selections, filters, toggles,
  password visibility, and form steps.
- Use **Bloc** for event-driven or multi-step flows such as authentication,
  meal analysis, AI conversations, and meal-plan generation.
- Keep states immutable and small. Do not create one global `AppBloc` or make
  feature Blocs depend directly on sibling Blocs.

## Shared code rules

- Put reusable visual components in `lib/core/widgets/` only when they are
  genuinely shared by more than one feature.
- Keep colors, assets, spacing, radii, typography, and theme configuration in
  `lib/core/theme/` or `lib/core/constants/`.
- Keep loading, error, and empty states reusable.
- Prefer composition and typed parameters over duplicated screen code.

## Navigation and composition

`go_router` is configured in `lib/app/router/app_router.dart`. Route guards for
authentication and onboarding will be added there when those Cubits exist.
App-level dependency registration belongs in `lib/app/app.dart`; feature
screens should receive dependencies through `RepositoryProvider` and
`BlocProvider`.

## Implementation order

1. Build UI with mock repositories and stable domain contracts.
2. Add authentication and onboarding persistence.
3. Connect nutrition APIs and Firebase repositories.
4. Add meal scanning and AI through a protected backend.
5. Add tests for Cubits, repositories, and critical user journeys.
