# Skill: Bloc and Cubit State Management

## Use this skill when

Adding or changing async workflows, form state, shared state, loading states,
failure handling, navigation side effects, or local interactive state.

## Choose the state manager

Use `Bloc<Event, State>` when the state is a shared or multi-step workflow:

- authentication and session changes;
- onboarding across multiple screens;
- dashboard loading and tab selection;
- meal analysis, AI conversations, or plan generation;
- async work with loading/success/failure states.

Use `Cubit<State>` for small local direct state:

- password visibility;
- a local toggle or selection;
- a screen-local filter;
- a small form preference that is not shared.

## Rules

- Keep states immutable and expose only the data the UI needs.
- Prefer `copyWith` or a new state over mutating an existing state.
- Keep business decisions in use cases/domain code.
- Let widgets dispatch events or call Cubit methods and render state.
- Use `BlocBuilder` for rendering.
- Use `BlocListener` or `BlocConsumer` for navigation, `AppToast`, and other
  one-time effects.
- Model initial, loading, success/data, empty, and failure states when they are
  meaningful for the workflow.
- Do not make sibling Blocs depend directly on each other.
- Do not create a second local copy of shared session or onboarding data.

## Workflow

1. Identify the state owner and whether another screen needs the state.
2. Define events and states before editing the UI.
3. Make the Bloc/Cubit depend on a use case, not a concrete data source.
4. Add explicit failure handling and user-facing feedback where appropriate.
5. Add a state-transition test that dispatches public events/methods.
6. Verify that navigation only happens from a listener, not from `build()`.

## Common mistakes

- Using Cubit for a workflow shared across screens.
- Showing a toast from `build()` and repeating it on every rebuild.
- Navigating directly from a repository.
- Treating a loading state as a boolean scattered across widgets.
- Testing private fields instead of observable state transitions.
