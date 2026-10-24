# Auth Feature Test Plan

## Acceptance matrix

- [ ] Valid sign in creates the expected session state.
- [ ] Invalid credentials produce a controlled failure and visible feedback.
- [ ] Sign up validates required fields and terms selection.
- [ ] Successful sign up preserves the current transition into onboarding.
- [ ] Sign out clears the shared session source of truth.
- [ ] Password visibility remains local UI state.
- [ ] Loading prevents duplicate submissions.

## Required executable coverage

- [x] Existing session state test: `test/features/auth_session_cubit_test.dart`.
- [ ] Sign-in Bloc/session event tests for success and failure.
- [ ] Sign-up validation and terms tests.
- [ ] Widget tests for sign-in/sign-up validation and navigation.
- [ ] Integration test for sign-up → onboarding.
