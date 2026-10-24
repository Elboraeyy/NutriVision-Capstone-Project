# Skill: Forms and Validation

## Use this skill when

Adding a form, multi-step input, search/filter fields, consent, validation, or
an async submit flow.

## Rules

- Keep business validation in reusable/domain validation code when it affects
  correctness; keep field formatting and focus behavior in presentation.
- Use one validation source of truth; do not duplicate the same rule in three
  widgets.
- Keep errors specific, actionable, readable, and accessible.
- Disable or guard duplicate submits while an async action is loading.
- Preserve entered values when a recoverable request fails.
- Use `AppToast` for a meaningful validation blocker only when visible inline
  validation is insufficient.

## Workflow

1. Define required, optional, format, range, and cross-field rules.
2. Define initial, editing, invalid, submitting, success, and failure states.
3. Reuse existing fields, buttons, spacing, and keyboard behavior.
4. Put multi-screen/shared form workflow in a Bloc; keep simple local fields
   local unless the data must survive navigation.
5. Test valid, invalid, empty, boundary, correction, duplicate-submit, and
   async-failure cases.
