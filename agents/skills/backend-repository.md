# Skill: Repository and Backend Integration

## Use this skill when

Replacing an in-memory repository, adding an API/local-storage data source, or
mapping external data into domain entities.

## Rules

- Keep the domain repository contract stable and backend-agnostic.
- Put concrete implementations under the feature's `data/` folder.
- Put API clients, storage access, DTOs, and mapping in `data/`.
- Return domain entities from repository methods.
- Convert external errors into a stable failure result understood by the
  domain/presentation layers.
- Keep credentials in environment/configuration mechanisms, never in source.
- Do not add Firebase, Dio, or another backend unless explicitly requested.
- Do not put network, storage, or serialization code in widgets, Blocs, or
  entities.

## Workflow

1. Read the existing domain repository interface and use cases.
2. Identify what the backend must provide and what the domain actually needs.
3. Add data models/DTOs only when they differ from domain entities.
4. Implement the repository contract in `data/repositories/`.
5. Map success and failure results at the repository boundary.
6. Register the implementation in `lib/app/app.dart`.
7. Test mapping, success, failure, empty data, and retry behavior.
8. Keep the presentation layer unchanged wherever the domain contract allows.

## Common mistakes

- Returning JSON maps to a Bloc.
- Importing an HTTP package into the domain layer.
- Creating a separate repository instance inside a screen.
- Logging credentials, tokens, or personal data in tests/output.
- Changing a domain contract unnecessarily when only the backend changed.
