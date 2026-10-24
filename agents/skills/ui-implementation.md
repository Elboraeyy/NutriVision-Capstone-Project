# Skill: NutriVision UI Implementation

## Use this skill when

Creating or changing screens, cards, forms, headers, navigation surfaces,
responsive layouts, or user feedback.

## Visual language

Preserve the established NutriVision design:

- cream backgrounds;
- dark green headers;
- floating cards and bottom navigation;
- rounded surfaces;
- responsive sizing;
- transparent overlay space around headers and floating navigation.

## Rules

- Reuse `AppColors`, `AppTheme`, `AppResponsive`, and `AppSystemUi`.
- Use `AppResponsive.value` and `AppResponsive.font` instead of device-specific
  magic numbers.
- Use `AppOverlayScaffold` when the header overlays scrollable content.
- Keep the home header, nutrition card, and bottom navigation floating/overlaid.
- Use shared controls from `lib/core/widgets/` before creating equivalents.
- Keep feature-specific widgets inside the feature.
- Use meaningful labels, readable contrast, and reasonable tap targets.
- Do not communicate essential information through color alone.

## Feedback

Use `AppToast` from `lib/core/widgets/app_toast.dart` only for meaningful
short-lived feedback:

- async success or failure;
- validation blockers;
- unavailable actions.

Do not add a toast for a screen opening, an ordinary selection, or a state that
is already obvious in the visible UI. Never introduce a raw `SnackBar`.

## Workflow

1. Inspect a visually similar existing screen.
2. Identify which pieces are route composition and which are reusable widgets.
3. Use existing theme and responsive helpers.
4. Add accessibility labels and check tap target sizes.
5. Use `BlocBuilder` for visual state and a listener for one-time effects.
6. Add/update a widget test for changed navigation or important UI behavior.
7. Run formatting, analyze, and tests.

## Common mistakes

- Replacing a floating/overlay layout with a full opaque page.
- Copying shared buttons or text fields into a feature.
- Hard-coding widths for one device size.
- Adding a toast for every normal state update.
- Moving feature widgets into `core` without a real cross-feature need.
