# NutriVision protected backend boundary

This folder is the planned home for server-side entry points that must not run
inside the Flutter client:

- API-key protected nutrition lookups.
- AI provider calls and prompt orchestration.
- Retrieval and context building.
- AI output schema validation and safety filters.
- Server-side aggregation or scheduled jobs.

The current repository does not select Firebase Functions, Supabase Edge
Functions, or another provider yet, so this is a documented scaffold rather
than an active backend. Select one provider before adding runtime code.

## Security rules

- Never commit secrets, service accounts, or production tokens.
- Keep user health data minimal and redact it from logs.
- Validate every external response and AI response.
- Keep provider credentials in the deployment environment.
- Add rate limits, timeout handling, and an explicit unavailable fallback.

## Planned folders

```text
backend/
  functions/  protected HTTP or callable entry points
  prompts/    versioned prompts without credentials
  schemas/    request/response and AI output schemas
  tests/      backend and AI evaluation tests
```
