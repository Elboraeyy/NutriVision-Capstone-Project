# Agent Task Template: AI Integration

```text
Read AGENTS.md, ARCHITECTURE.md, agents/skills/ai-integration.md,
agents/skills/security-privacy.md, and agents/tests/stages/05-ai-test.md.

AI capability: <meal analysis/recommendation/chat/etc.>
User input: <text/image/structured data>
Expected output schema: <typed fields>
Backend boundary: <service endpoint or repository contract>
Fallback: <what happens when AI is unavailable>
Privacy/retention: <data handling policy>

Requirements:
- Never put provider keys or privileged calls in Flutter.
- Validate input and model output against a typed contract.
- Version prompts and schemas.
- Handle timeout, quota, rate limit, outage, unsafe, ambiguous, and malformed
  responses.
- Add deterministic fake tests and an evaluation set with safety cases.
- Avoid medical certainty and protect health-sensitive data.
```
