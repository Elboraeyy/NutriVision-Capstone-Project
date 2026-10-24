# Agent Task Template: API Integration

```text
Read AGENTS.md, ARCHITECTURE.md, agents/skills/api-integration.md,
agents/skills/security-privacy.md, and agents/tests/stages/04-data-api-test.md.

API task: <name>
Domain action: <what the app needs>
Contract: <method/path/request/response/errors>
Auth: <user/session/service boundary>
Offline/cache policy: <policy>

Requirements:
- Keep transport code in data/.
- Keep domain entities and repository contracts backend-agnostic.
- Define timeouts, cancellation, bounded retries, and auth expiry.
- Never expose secrets in the Flutter client or tests.
- Add mapper, repository, failure, and integration tests.
- Update the feature test artifact and run all verification commands.
```
