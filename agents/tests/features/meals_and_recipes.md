# Meals & Recipe Integration Test Plan

## Scope

Verifies the branch unification on `main`:

- `menna`: `PlusJakartaSans` font family configured in `AppTheme.light` and `pubspec.yaml`.
- `hager`: `CameraScannerScreen`, `AnalyzingMealScreen`, `MealScreen`,
  `MealDetailsScreen`, and `RecipeDetailsScreen` organized under
  `lib/features/meals/presentation/screens/` and
  `lib/features/recommendations/presentation/screens/`, wired in `AppRouter` and
  `HomeScreen` alongside `Hoda`'s `water_tracker`.

## Verification Cases

1. `AppTheme.light` includes `PlusJakartaSans` typography from `menna`.
2. Each of the five meal and recipe screens renders cleanly without missing-asset
   crashes, overflow, or raw `SnackBar` usage.
3. Navigation from `HomeScreen` through `AppRouter` reaches:
   - `Scan a meal` -> `CameraScannerScreen` -> `AnalyzingMealScreen` -> `MealScreen`
   - `+  Log food manually` -> `MealScreen`
   - Recent meal card (`Chicken & quinoa bowl`) -> `MealDetailsScreen`
   - AI suggestion card (`Lemon salmon & couscous`) and `Discover` tab ->
     `RecipeDetailsScreen`

## Executable Proof

- [`test/features/meals_and_recipes_test.dart`](../../../test/features/meals_and_recipes_test.dart)
