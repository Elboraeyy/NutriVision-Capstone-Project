# Skill: Design System and Reusable UI

## Use this skill when

Creating a screen, extending the NutriVision visual language, extracting a
widget, responding to a design reference, or fixing repeated UI code.

## Design tokens

Use the existing sources of truth:

- `AppColors` for color roles;
- `AppTheme` for typography and component theme;
- `AppResponsive.value` and `AppResponsive.font` for responsive sizing;
- `AppSystemUi` for system chrome;
- `AppOverlayScaffold` for overlay-header layouts;
- `AppToast` for short-lived contextual feedback.

Do not introduce a second color, spacing, radius, typography, or responsive
system inside a feature.

## Reusable widget decision

Extract a widget when it has a clear name, a typed input/output contract, and
is reused or clearly represents a stable feature section. Keep it feature-local
when it encodes feature-specific behavior. Move it to `lib/core/widgets/` only
when at least two features need the same behavior and visual contract.

## Workflow

1. Find the closest existing screen or shared control.
2. Preserve the cream background, dark green header, floating surfaces, and
   transparent overlay space unless a product request changes them.
3. Build responsive layouts for narrow, normal, and wide widths.
4. Add semantic labels, adequate tap targets, and readable contrast.
5. Separate visual composition from state and business logic.
6. Add a widget/visual acceptance checklist under `agents/tests/stages/`.
7. Verify with widget tests and a manual responsive review.

## Common mistakes

- Copying an existing card instead of extracting its reusable behavior.
- Creating a `core` widget that still depends on one feature's data model.
- Using color as the only error/success signal.
- Hard-coding dimensions for one device.
- Rebuilding the home floating layout as an opaque full-screen page.
