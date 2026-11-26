# Profile & Notifications Settings Test Plan

## Acceptance matrix

### Profile & Settings
- [x] Profile screen renders the dark green header (`NutriVision`, `Profile & settings.`, `Your nutrition, your way.`), floating profile summary card, `Account settings` section with 4 rows, and bottom navigation with `Profile` selected.
- [x] Profile card shows the current authenticated user's name when available and falls back to `Maya` with subtitle `Your NutriVision profile`.
- [x] `Goals & Dietary Preferences` navigates to the existing `/onboarding/goal` (`onboarding-goal`) route.
- [x] `Notifications Settings` navigates to `/profile/notifications` (`notifications-settings`).
- [x] `Privacy & Data Management` shows `AppToast` info feedback because its destination route is not yet implemented.
- [x] `Sign out` opens a confirmation dialog; cancelling keeps the session intact, and confirming dispatches `SignOutRequested` and navigates to `/sign-in` (`sign-in`).

### Notifications Settings
- [x] Screen renders the green header with `Profile & Settings` back link, `Notifications settings.`, `A routine that works for you.`, and all 4 cards + `Save changes` button + bottom navigation bar with `Profile` selected.
- [x] Permission status is checked without prompting on load and updates for `notChecked`, `granted`, `denied`, and `permanentlyDenied` (with `Open app settings`).
- [x] Meal logging, water, reminder sound, and quiet hours remain editable drafts until `Save changes` is pressed (no active scheduling).
- [x] Quiet hours dialog uses Flutter's time picker and validates start/end times (supporting overnight ranges and rejecting equal or <30-minute ranges).
- [x] `Save changes` validates settings, persists to `SharedPreferences`, updates draft/saved status text, and restores saved settings when reopening the screen.
- [x] Responsive layout renders without overflow at `320x568`, `390x844`, and `600x900`.

## Executable coverage

- `test/features/profile_bloc_test.dart`: `InMemoryProfileRepository`, `GetUserProfile`, and `ProfileBloc`.
- `test/features/profile_screen_test.dart`: `ProfileScreen` UI, navigation, sign-out dialog, and bottom navigation.
- `test/features/notifications_settings_bloc_test.dart`: `QuietHoursRange` validation, JSON model round-trip/corrupt handling, `SaveNotificationSettings` validation, `LocalNotificationSettingsRepository` persistence, and `NotificationsSettingsBloc` state transitions.
- `test/features/notifications_settings_screen_test.dart`: `NotificationsSettingsScreen` UI, dropdowns, quiet hours picker, permission states, persistence across reopen, and navigation.
