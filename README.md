# NutriVision

### AI-Driven Dietary Health Assistant

NutriVision is a cross-platform Flutter application that helps users make better dietary decisions through AI-powered nutritional guidance, meal analysis, healthy alternatives, and personalized recipe suggestions.

## Main Features

- AI-generated nutritional advice and personalized recipes.
- Healthy alternatives based on user preferences and dietary restrictions.
- Meal history and nutritional insights.
- Meal-log synchronization through a backend repository (planned integration).
- Responsive and user-friendly interface.

## Technologies

- Flutter & Dart
- `flutter_bloc` for state management
- `go_router` for navigation
- Git & GitHub
- Unit and widget testing

The current repositories use in-memory implementations so the UI and domain
flows can be developed independently of a backend. A production API or cloud
database can be added later behind the existing repository contracts.

## Architecture

The project follows Clean Architecture by feature:

```text
lib/features/<feature>/
  data/          concrete repository implementations
  domain/        entities, repository contracts, use cases
  presentation/ blocs, cubits, screens, and widgets
```

Shared repositories are registered in `lib/app/app.dart` with
`MultiRepositoryProvider`, then injected into feature use cases and blocs.
Feature workflows use `Bloc<Event, State>`; Cubit is reserved for small local
UI state such as password visibility and terms selection. Home dashboard
sections live in `lib/features/home/presentation/widgets/` so route screens
stay focused on composition.

For the complete coding-agent rules and project conventions, read
[`AGENTS.md`](AGENTS.md).

## iOS IPA builds

The GitHub Actions workflow in [`.github/workflows/ios-ipa.yml`](.github/workflows/ios-ipa.yml)
builds and uploads an unsigned IPA artifact on pushes to `main` or manual
workflow runs. See [`docs/ios-ipa.md`](docs/ios-ipa.md) for download and Apple
signing details.

## Team

- Mohamed Samy
- Hager Awadeen
- Menna Khalill
- Hoda Mohamed
- Nancy Ahmed

## Instructor

- Rana Mohy

## Project

This is the graduation project of the fifth round of the Digital Egypt Pioneers Initiative (DEPI), Cross-Platform / Flutter track.

The project is actively being built. Run `dart format .`, `flutter analyze`,
and `flutter test` before submitting changes.
