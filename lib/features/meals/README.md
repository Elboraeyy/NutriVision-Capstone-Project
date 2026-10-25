# Meals feature

Owns meal entry, meal history, daily summaries, and the user's saved meal
records. It coordinates nutrition data through repository contracts; it does
not call nutrition APIs directly from screens.

Recommended first slice:

1. Define meal and daily-summary entities.
2. Define create, list, update, and delete use cases.
3. Add the repository and an in-memory implementation for UI development.
4. Add Firestore or API data sources only behind the repository.
5. Use a Bloc for loading, saving, deleting, and failure states.
