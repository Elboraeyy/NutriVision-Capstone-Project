# Progress & Insights Test Plan

## 1. User Outcome

Users can monitor daily calorie and macro intake against personalized goals (`ProgressScreen`, tab index 3) and inspect time-range nutrition comparisons, protein gap suggestions, and logging patterns (`InsightsScreen`).

## 2. Scope

- **In scope:**
  - `ProgressSnapshot`, `NutrientComparison`, `WeeklyNutrientDay`, `InsightSuggestion`, `ProgressPattern` domain entities (no Flutter imports).
  - `ProgressRepository` contract and `InMemoryProgressRepository` supporting `today`, `last7Days`, and `last30Days` ranges.
  - `GetProgressSnapshot` use case.
  - `ProgressBloc` managing initial load, date-range changes, loading, success, and failure states.
  - `ProgressScreen` (Figma `206:6306`) and `InsightsScreen` (Figma `206:6202`) with centered headers, floating top cards/pills, and scrollable bodies underneath.
  - Navigation wiring from `AppFloatingNavigationBar` index 3 across `HomeScreen`, `MealPlanScreen`, `DiscoverScreen`, `RecipeSearchScreen`, and `SavedRecipesScreen`.
- **Out of scope:**
  - Live backend persistence or real-time meal-log aggregation until backend endpoints are connected.

## 3. Executable Test Cases (`test/features/progress_test.dart`)

1. `InMemoryProgressRepository` returns accurate snapshots for `today`, `last7Days`, and `last30Days`.
2. `ProgressBloc` emits `[loading, success]` on `ProgressStarted`.
3. `ProgressBloc` updates `selectedRange` and snapshot on `ProgressRangeChanged`.
4. `ProgressBloc` emits `ProgressStatus.failure` with user-friendly message when repository throws.
5. `ProgressScreen` renders `Progress` header, `Daily intake` floating card, `This week` table, and `View Insights & Patterns` card without overflow across compact and wide viewports.
6. `InsightsScreen` renders `Insights` header, `DateRangeSelectorPill`, `Nutrition comparisons`, `PROTEIN SUGGESTION`, `Emerging patterns`, and range-switching bottom sheet.
