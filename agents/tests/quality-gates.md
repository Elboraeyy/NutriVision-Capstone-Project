# NutriVision Quality Gates

An agent must pass the relevant gates before declaring a task complete.

## Gate 1: Scope and acceptance

- [ ] User outcome is written in observable terms.
- [ ] In-scope and out-of-scope behavior is explicit.
- [ ] Loading, empty, failure, validation, offline, and unavailable states are
      considered.
- [ ] A feature-specific test artifact exists or was updated.

## Gate 2: Architecture

- [ ] Feature code follows `data/domain/presentation`.
- [ ] Domain has no Flutter or transport imports.
- [ ] Screens/widgets do not call repositories, APIs, storage, or AI providers.
- [ ] Repositories are injected from `lib/app/app.dart`.
- [ ] Routes are centralized in `lib/app/router/app_router.dart`.
- [ ] Bloc/Cubit choice is justified and state is immutable.
- [ ] Repeated behavior uses an existing or intentionally new reusable widget.

## Gate 3: User experience

- [ ] Existing NutriVision visual language is preserved.
- [ ] Responsive behavior works at narrow, normal, and wide sizes.
- [ ] Accessibility labels, contrast, focus, and tap targets are considered.
- [ ] AppToast is used only for meaningful short-lived feedback.
- [ ] Error and empty states are visible and actionable.

## Gate 4: Data, API, and AI

- [ ] External data is mapped at the data boundary.
- [ ] Timeouts, cancellation, retry, and auth-expiry behavior are explicit.
- [ ] Secrets are not present in the client, source, tests, or logs.
- [ ] AI output is schema-validated and has a safe fallback.
- [ ] PII/health data is minimized and redacted.

## Gate 5: Verification

- [ ] `dart format .`
- [ ] `flutter analyze`
- [ ] `flutter test`
- [ ] Relevant integration/evaluation tests
- [ ] `git diff --check`
- [ ] No generated files, secrets, or unrelated changes
