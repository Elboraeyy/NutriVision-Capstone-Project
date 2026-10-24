# Onboarding Feature Test Plan

## Acceptance matrix

- [ ] Goal selection updates the shared onboarding draft.
- [ ] Dietary preferences, favorite foods, and allergies remain in one draft.
- [ ] Draft saving reports loading, success, and failure correctly.
- [ ] Reset returns the draft to its initial state.
- [ ] Completion validates required information and persists the result.
- [ ] Back/next navigation does not create duplicate local state.
- [ ] Completion failure keeps the user on a recoverable screen.

## Required executable coverage

- [x] Existing onboarding state test: `test/features/onboarding_cubit_test.dart`.
- [ ] Bloc event tests for every draft mutation.
- [ ] Save/complete use case tests.
- [ ] Widget tests for all step validation and navigation.
- [ ] Integration test for account creation through onboarding completion.
