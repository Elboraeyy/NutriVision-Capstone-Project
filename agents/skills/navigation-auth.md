# Skill: Navigation, Authentication, and Onboarding

## Use this skill when

Adding a route, changing auth transitions, changing onboarding completion, or
connecting a screen to the existing navigation flow.

## Rules

- Centralize routes in `lib/app/router/app_router.dart`.
- Use named routes or existing route paths.
- Do not push ad-hoc route instances from feature widgets.
- Drive auth and onboarding transitions from Bloc state/listeners.
- Do not use hidden globals or direct repository checks in screens.
- Preserve the current temporary behavior: account creation opens onboarding.
- Put navigation side effects in `BlocListener`/`BlocConsumer`, not `build()`.

## Workflow

1. Inspect the current route table and auth/session state.
2. Decide whether the route is public, authenticated, or onboarding-only.
3. Add the route with the existing naming/path conventions.
4. Connect transitions to observable Bloc state.
5. Handle loading, failure, and unavailable actions with visible UI or
   `AppToast` when short-lived feedback is useful.
6. Add a widget test for the important route transition.

## Common mistakes

- Navigating before the async state is successful.
- Triggering navigation on every rebuild.
- Re-implementing auth state in a screen.
- Changing the account-creation flow without product-owner approval.
- Adding a route that bypasses the centralized router.
