# Profile and Onboarding Preferences Integration Plan

## Acceptance matrix

- [ ] Completing onboarding writes the selected goal, dietary pattern, favorite
  foods, and allergies to the signed-in user's profile preference record.
- [ ] Selecting `None` writes an empty allergy list and clears previous choices.
- [ ] Profile loads saved preferences using the authenticated user's ID.
- [ ] Profile edits start from saved values and save under the same user ID.
- [ ] A second user ID cannot read the first user's preference record.
- [ ] Preferences remain available after sign out and sign in with the same ID.
- [ ] Targets and excluded ingredients already saved for that user survive
  onboarding completion.

## Executable coverage

- `test/features/onboarding_cubit_test.dart` covers completion mapping, the
  `None` allergy case, user isolation, and sign-out/sign-in persistence.
- `test/features/goals_dietary_bloc_test.dart` covers user-scoped loading,
  editing, saving, and reopening the profile preference record.
- `test/features/goals_dietary_screen_test.dart` covers the authenticated
  profile screen wiring and edit/save UI.

## Storage note

The current app uses local `SharedPreferences` and mock authentication; there is
no remote database or real account service in this repository. This integration
uses the existing local mechanism and isolates records by authenticated user
ID. It does not sync preferences across devices.
