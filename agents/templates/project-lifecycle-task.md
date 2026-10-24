# Agent Task Template: Full Project Lifecycle

Copy this prompt for a substantial feature or integration:

```text
Read AGENTS.md, ARCHITECTURE.md, agents/README.md, and the relevant skills
before editing.

Task: <feature or change>
User outcome: <observable outcome>
Scope: <in scope>
Out of scope: <out of scope>

Follow this lifecycle:
1. Inspect the existing implementation and preserve unrelated changes.
2. Write acceptance criteria and create/update agents/tests/features/<name>.md.
3. Map the feature to data/domain/presentation and identify reusable code.
4. Decide Bloc versus Cubit and define loading/error/empty/offline states.
5. Define API/AI/security/privacy contracts if applicable.
6. Implement through use cases, repository contracts, and app.dart injection.
7. Add executable tests for each affected layer and critical journey.
8. Run architecture, duplication, security, accessibility, and regression audit.
9. Run dart format ., flutter analyze, and flutter test.
10. Report changed files, tests, checks, limitations, and follow-up work.
```
