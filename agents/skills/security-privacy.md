# Skill: Security and Privacy Review

## Use this skill when

Handling authentication, tokens, health/nutrition data, images, AI prompts,
analytics, API integration, local storage, or release configuration.

## Non-negotiable rules

- Never commit secrets, API keys, signing keys, tokens, or credentials.
- Never expose privileged AI/API keys in a Flutter client.
- Minimize collection and retention of personal and health-sensitive data.
- Redact sensitive values from logs, exceptions, screenshots, tests, and crash
  reports.
- Validate input at every trust boundary and validate external output before
  use.
- Use least-privilege access and explicit authorization checks.
- Make consent, deletion, logout cleanup, and unavailable-service behavior
  visible where relevant.

## Review checklist

- threat model for the feature and trust boundaries;
- authentication and authorization behavior;
- token storage and expiry handling;
- transport security and certificate/configuration assumptions;
- input validation and output/schema validation;
- PII/health data in logs and analytics;
- prompt injection and untrusted AI output;
- dependency and supply-chain changes;
- release configuration and environment separation.

## Response to a suspected secret

Stop, do not print it, remove it from the working tree, check whether it was
committed, rotate/revoke it through the owning service, and document the safe
remediation. Do not rewrite history casually without owner approval.
