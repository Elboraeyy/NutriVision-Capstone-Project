# NutriVision AI Agent Instructions

This file is the canonical instruction source for AI coding agents working in
this repository. Read it before changing code. If another agent-specific file
links here, these rules remain the source of truth.

Reusable project-specific skills and task templates are collected in
[`agents/README.md`](agents/README.md). Tool-specific instruction files remain
in their standard discovery paths and are indexed there.

## Project context

NutriVision is a Flutter/Dart nutrition assistant app. The current app includes
authentication, onboarding, a home dashboard, shared responsive UI, and an
in-memory data layer used until a real backend is connected.

The UI is intentionally designed around the existing NutriVision visual
language: cream backgrounds, dark green headers, floating cards/navigation,
rounded surfaces, responsive sizing, and transparent overlay space around
headers and floating navigation. Preserve that language when adding screens.

When communicating with the project owner, prefer Arabic unless the owner asks
for another language. Keep code, identifiers, file names, and comments in
English.

## Non-negotiable architecture

Use Clean Architecture inside each feature:

```text
lib/features/<feature>/
  data/
    repositories/       # concrete data sources/repository implementations
  domain/
    entities/           # business models; no Flutter UI dependencies
    repositories/       # abstract repository contracts
    usecases/           # one business action per use case
  presentation/
    bloc/               # feature-wide workflows: Bloc<Event, State>
    cubit/              # small/local state only
    screens/            # route-level screens
    widgets/            # reusable feature widgets
```

The app composition root is `lib/app/app.dart`:

- Register repository abstractions with `MultiRepositoryProvider`.
- Build use cases from the repositories provided by context.
- Register feature state managers with `MultiBlocProvider`.
- Do not instantiate repositories repeatedly inside screens or in arbitrary
  widget `build` methods.

Repositories are backend-agnostic. The current `InMemory...Repository`
implementations are placeholders. When a backend is added, implement the
existing domain repository contract in `data/`; do not put API, Firebase, or
storage code in widgets, blocs, or domain entities. Do not add Firebase or any
other backend merely as an example or without an explicit requirement.

## Bloc and Cubit policy

Use a real `Bloc<Event, State>` for shared or multi-step application flows.
The current primary blocs are:

- `AuthSessionBloc`: sign in, sign up, and sign out events.
- `OnboardingBloc`: goal, dietary preferences, favorite foods, allergies,
  draft saving, reset, and completion events.
- `HomeBloc`: dashboard loading and tab selection events.

Use `Cubit<State>` only for small, local, direct state changes. Current
examples are `SignInCubit` and `SignUpCubit` for password visibility and terms
selection.

Before adding state logic, decide whether it is local UI state or a feature
workflow. If multiple screens, async work, persistence, navigation side
effects, loading, or failure states are involved, use a Bloc event and state.

Rules for blocs/cubits:

- Keep business decisions in use cases/domain layers where appropriate.
- Keep widgets responsible for rendering and dispatching events only.
- Use `BlocBuilder` for rendering state and `BlocListener`/`BlocConsumer` for
  navigation, `AppToast` messages, and other one-time side effects.
- Model loading, success, and failure explicitly for async operations.
- Keep states immutable and update them through `copyWith` or a new state.
- Keep one source of truth for data shared by several screens. Do not create
  duplicate local copies of onboarding or session state.
- Do not call repository methods directly from a screen.

## UI and design rules

- Reuse tokens and helpers in `lib/core/theme/`, especially `AppColors`,
  `AppResponsive`, `AppTheme`, and `AppSystemUi`.
- Reuse shared controls from `lib/core/widgets/` before creating another
  equivalent component.
- Use `AppToast` from `lib/core/widgets/app_toast.dart` for every in-app
  notification. Never introduce a raw `SnackBar` or a feature-specific toast.
  Select `success`, `error`, `warning`, or `info` according to the situation.
- When implementing any new feature or changing an existing flow, review its
  user feedback and add an `AppToast` only when it communicates something the
  user needs to know. Appropriate cases include a meaningful async success or
  failure, a validation blocker, or an unavailable action. Do not add a toast
  merely because a feature exists, a screen opened, a normal selection changed,
  or a state update is already obvious in the UI. Prefer the visible UI for
  persistent state and reserve toasts for short-lived contextual feedback.
- Use `AppOverlayScaffold` for screens whose header overlays scrollable content.
  Keep the space around headers transparent and allow the body to scroll behind
  the header when that is the established design.
- Keep the home header, nutrition card, and bottom navigation floating/overlaid
  as currently designed. Do not replace them with a full-screen opaque layout
  unless explicitly requested.
- Put feature-specific cards and reusable sections in that feature's
  `presentation/widgets/` directory. Keep route screens thin.
- Use `AppResponsive.value` and `AppResponsive.font` instead of scattering
  hard-coded device-specific sizes.
- Preserve accessibility: meaningful labels, readable contrast, reasonable
  tap targets, and no important information conveyed by color alone.

## Navigation and auth flow

- Routing is centralized in `lib/app/router/app_router.dart` using `go_router`.
- Use named routes or the existing route paths instead of pushing ad-hoc route
  instances from feature widgets.
- Keep authentication and onboarding transitions driven by Bloc state/listener
  behavior, not by hidden global flags or direct repository access.
- The temporary behavior after account creation opens onboarding. Preserve it
  until the product owner requests a different flow.

## Agent operating protocol

For every meaningful task, use the project lifecycle in
[`agents/README.md`](agents/README.md): discover, plan, design, build, test,
audit, and handoff.

Before editing:

- Read this file and [`ARCHITECTURE.md`](ARCHITECTURE.md).
- Read the relevant skill under [`agents/skills/`](agents/skills/).
- Inspect the existing feature, tests, router, composition root, and shared
  widgets before creating new code.
- Preserve unrelated working-tree changes.

During implementation:

- Search for existing widgets, validators, mappers, formatters, and state before
  creating a duplicate.
- Extract repeated behavior into a small typed reusable widget/helper in the
  nearest correct layer.
- Keep feature-specific behavior in the feature; move code to `core/` only when
  it is genuinely cross-feature.
- Create or update a feature-specific test artifact under `agents/tests/`.
- If inherited code violates this architecture, repair the smallest safe slice,
  add regression coverage, and document the repair instead of extending the
  violation.

For API or AI work:

- Keep network, storage, and provider SDK code behind data/repository boundaries.
- Never put API keys, AI provider secrets, or privileged calls in the Flutter
  client, source control, test fixtures, or logs.
- Validate external data and AI output before using it in the UI.
- Define timeout, cancellation, retry, offline, quota, unsafe, and unavailable
  behavior explicitly.
- Protect and minimize personally identifiable and health-sensitive data.

## Reuse and quality policy

- Prefer composition and small reusable widgets over copy/paste screens.
- Use one source of truth for shared data and one canonical design-token system.
- Do not add a dependency, global manager, service locator, or generic framework
  when existing project code can solve the problem.
- A task is not complete until the applicable architecture, UI, data/security,
  and test gates in `agents/tests/quality-gates.md` are reviewed.

## Testing and verification

For every meaningful code change:

1. Run `dart format .`.
2. Run `flutter analyze`.
3. Run `flutter test`.

Feature state tests should dispatch Bloc events and assert resulting states,
rather than testing private implementation details. Add widget tests when a UI
flow, navigation behavior, or shared widget changes.

For every meaningful feature or integration, create or update a plan under
`agents/tests/` and add executable tests under `test/` or `integration_test/`.
Use unit tests for domain/data logic, Bloc/Cubit tests for state transitions,
widget tests for UI and wiring, integration tests for critical journeys, and
AI evaluation cases for quality, safety, schema validity, and fallback behavior.

Before declaring a task complete, verify that:

- no old imports or dead state managers remain;
- the feature gives clear feedback for meaningful success, failure,
  validation-blocked, and unavailable-action paths when a toast is appropriate;
- no redundant, repetitive, or noisy toasts were added for ordinary UI state
  changes or navigation;
- no generated files, build output, secrets, credentials, or personal IDE
  settings were added;
- the existing visual behavior was not unintentionally changed;
- the working tree contains only intended changes.

## Working conventions

- Inspect the relevant existing code before editing it.
- Make focused changes and preserve unrelated user changes.
- Prefer small reusable widgets and use cases over large screen files.
- Use `apply_patch` for source edits when working through an agent terminal.
- Do not use destructive reset/checkout commands to discard work.
- Do not introduce a new dependency when the current Flutter SDK or existing
  packages can solve the problem.
- Never commit secrets. Use environment/configuration mechanisms for future
  credentials.

## Commit guidance

Use a short imperative commit message, for example:

```text
feat: add meal history flow
fix: preserve onboarding draft
refactor: split home dashboard widgets
```

Keep unrelated changes in separate commits.
