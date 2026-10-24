# Stage 02 Test: Architecture and Dependency Direction

## Checklist

- [ ] `lib/features/<feature>/data/` contains concrete implementations only.
- [ ] `lib/features/<feature>/domain/` contains entities, contracts, and use
      cases only.
- [ ] `lib/features/<feature>/presentation/` contains UI and state managers.
- [ ] Domain imports do not depend on Flutter, HTTP, storage, or AI SDKs.
- [ ] Presentation does not call repositories directly.
- [ ] Dependencies are registered once in `lib/app/app.dart`.
- [ ] Routes are registered centrally.
- [ ] Shared state has one source of truth.
- [ ] Duplicate widgets/helpers/validators were extracted or intentionally
      rejected with a reason.

## Executable proof

- [ ] Use case tests.
- [ ] Repository/fake tests.
- [ ] Bloc/Cubit state transition tests.
- [ ] Widget/provider wiring test when composition changed.
