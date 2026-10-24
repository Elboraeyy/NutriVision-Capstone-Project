# Skill: API Integration

## Use this skill when

Connecting a repository to HTTP/REST/GraphQL, adding authentication headers,
pagination, uploads, retries, caching, or an API-backed domain action.

## Boundary rules

- The Flutter client talks to a backend contract, not directly to privileged
  provider credentials or internal services.
- Put HTTP clients, DTOs, serializers, interceptors, and mapping in `data/`.
- Keep domain entities and repository interfaces independent of transport.
- Use typed request/response models and explicit failure categories.
- Keep base URLs, timeouts, and feature flags in configuration, not widgets.
- Never log access tokens, health data, prompts, or full user payloads.

## Contract-first workflow

1. Define the domain action and acceptance criteria.
2. Write the API contract: method, path, auth, request, response, pagination,
   errors, idempotency, and versioning.
3. Add DTOs and mapping at the data boundary.
4. Implement the domain repository contract.
5. Add timeout, cancellation, retry, backoff, and offline behavior deliberately.
6. Map HTTP failures into stable domain failures.
7. Add fake-based tests for success, malformed data, auth expiry, timeout,
   rate limiting, server error, empty data, and retry.
8. Register the implementation through `lib/app/app.dart`.

## Reliability defaults

- Retry only safe/idempotent operations unless the server supports idempotency
  keys.
- Use bounded exponential backoff with jitter.
- Treat authentication expiry separately from network failure.
- Do not retry validation errors or permission failures.
- Make pagination and cache invalidation explicit.

## Common mistakes

- Returning raw JSON maps to a Bloc.
- Embedding an API key in a Flutter binary.
- Retrying every status code forever.
- Hiding a server error as an empty list.
- Changing a domain contract just to mirror one API response.
