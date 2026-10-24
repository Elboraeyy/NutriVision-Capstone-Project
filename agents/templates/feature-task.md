# Agent Task Template: New Feature

Copy this prompt when assigning a feature to an AI agent:

```text
Read AGENTS.md, ARCHITECTURE.md, and agents/skills/flutter-feature.md before
editing. Implement the following feature:

Feature: <name>
User outcome: <what the user should be able to do>
Routes/screens: <existing or new routes>
Data needed: <entity/repository/use cases>
State behavior: <Bloc workflow or local Cubit state>

Requirements:
- Preserve unrelated working-tree changes.
- Follow the feature-first Clean Architecture.
- Keep repositories behind domain contracts and use cases.
- Register dependencies in lib/app/app.dart.
- Use named routes from lib/app/router/app_router.dart.
- Reuse NutriVision theme helpers and shared widgets.
- Add appropriate tests and AppToast feedback only when useful.
- Run dart format ., flutter analyze, and flutter test.

Report changed files, verification results, and limitations.
```
