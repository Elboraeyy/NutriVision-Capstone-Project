# Skill: Performance, Responsiveness, and Accessibility

## Use this skill when

Adding a list, image/AI scan, animation, expensive computation, responsive
layout, accessibility behavior, or a screen that must work across devices.

## Performance rules

- Keep expensive work out of `build()` and isolate it behind use cases/services.
- Use lazy lists for unbounded content.
- Avoid rebuilding large subtrees when a smaller `BlocBuilder` is sufficient.
- Constrain image size, decode work, and cache policy deliberately.
- Cancel stale requests and avoid duplicate concurrent actions.
- Measure with Flutter DevTools before optimizing speculative code.

## Responsive/accessibility rules

- Use `AppResponsive` helpers and test narrow, normal, and wide layouts.
- Maintain readable contrast, semantics, labels, focus order, and tap targets.
- Do not rely on color, hover, animation, or sound alone for essential meaning.
- Respect text scaling, reduced motion, keyboard/focus input, and localization
  direction where applicable.
- Test long text, empty data, error states, and large accessibility text.

## Workflow

1. Define the performance or accessibility acceptance criterion.
2. Implement the simplest correct composition.
3. Add targeted widget tests and a responsive/accessibility checklist.
4. Inspect with Flutter DevTools when the change affects rendering, memory,
   network, or frame time.
5. Record measured regressions or confirm that no relevant regression exists.
