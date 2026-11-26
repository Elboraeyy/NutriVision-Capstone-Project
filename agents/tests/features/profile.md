# Profile & Settings Test Plan

## User outcomes

1. User opens Profile & Settings from the floating navigation bar (`Profile` tab) and sees their name, avatar, and Account settings options.
2. User opens **Goals & Dietary Preferences**, edits their goal, allergies, daily targets, dietary pattern, or food preferences, and saves changes with validation and `AppToast` feedback.
3. User opens **Notifications Settings**, chooses device permission, meal/water reminder schedules, sound, and quiet hours, and saves changes.
4. User opens **Privacy & Data Management**, toggles meal photo AI consent, requests a data export, or confirms permanent account/data deletion.
5. User taps **Sign out**, confirms in the modal dialog, and is signed out via `AuthSessionBloc`.

## Architecture & quality checks

- `lib/features/profile/domain/` contains pure Dart entities, repository contract, and use cases without Flutter imports.
- `InMemoryProfileRepository` syncs shared goal, dietary pattern, favorite foods, and allergies with `OnboardingRepository`.
- `ProfileRepository` and `ProfileBloc` are registered in `lib/app/app.dart`.
- Routes `/profile`, `/profile/goals`, `/profile/notifications`, `/profile/privacy` are centralized in `lib/app/router/app_router.dart`.
- `AppToast` is used for async feedback and validation blockers.

## Executable tests

- `test/features/profile_test.dart`
  - Unit tests: `InMemoryProfileRepository` onboarding sync, `UpdateGoalsAndPreferences` range validation.
  - Bloc tests: `ProfileBloc` transitions for load, goals save, notifications save, AI photo consent toggle, data export, account deletion, and failure.
  - Widget tests: `ProfileScreen`, `SignOutConfirmationDialog`, `GoalsPreferencesScreen`, `NotificationsSettingsScreen`, `PrivacyDataScreen`, and narrow `360x640` layout check.
