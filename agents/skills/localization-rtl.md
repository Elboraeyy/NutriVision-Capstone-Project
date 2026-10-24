# Skill: Localization and RTL Readiness

## Use this skill when

Adding user-facing text, Arabic support, right-to-left layouts, date/number
formatting, or content that may grow beyond English labels.

## Rules

- Do not scatter user-facing strings through widget code when localization is
  expected; use a centralized string source when the project adopts one.
- Never assume text length, word order, or left-to-right direction.
- Use directional padding/alignment APIs where the layout is directional.
- Keep icons and actions semantically correct in RTL.
- Format dates, times, decimals, and units for the active locale.
- Keep technical identifiers, file names, and code comments in English.

## Workflow

1. Identify all user-facing strings and their context.
2. Check long Arabic/English variants and mixed numeric content.
3. Test RTL layout, text scaling, overflow, and accessibility labels.
4. Keep nutrition/health terminology reviewed and unambiguous.
5. Add localization regression cases for every changed screen.
