# Stage 08 — Architecture scaffold and handoff

## Outcome

The repository exposes a predictable Clean Architecture layout for existing
and planned features without adding fake backend implementations.

## Acceptance criteria

- Existing workflow features keep `data/domain/presentation` boundaries.
- Planned `nutrition`, `meals`, `ai_assistant`, and `recommendations` features
  have all standard layer directories.
- Shared `core` folders have explicit ownership rules.
- Protected backend responsibilities are documented outside `lib/`.
- Static `splash` and `welcome` screens are not forced into empty business
  layers.
- No credentials, generated files, provider SDKs, or runtime behavior are
  introduced by the scaffold.

## Verification

```text
dart format .
flutter analyze
flutter test
git diff --check
```

## Next implementation order

1. Define nutrition domain entities and repository contracts.
2. Add an in-memory nutrition repository and tests.
3. Add meal logging through the nutrition contract.
4. Select and implement the protected backend boundary.
5. Add AI schemas, prompts, provider adapter, and evaluation cases.
