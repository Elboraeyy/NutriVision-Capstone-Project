# Skill: Release, CI, and Observability

## Use this skill when

Changing build configuration, CI workflows, environment configuration,
telemetry, logging, crash reporting, release checks, or rollback behavior.

## Rules

- Keep environments and secrets separate from source code.
- Make CI run formatting, analysis, tests, and relevant build checks.
- Do not log tokens, prompts, images, health data, or raw user payloads.
- Prefer structured redacted events over ad-hoc print statements.
- Define what is measured, why it is needed, retention, and access.
- Make feature flags and rollback behavior explicit for risky integrations.

## Release workflow

1. Confirm acceptance criteria and version/configuration changes.
2. Run the full verification suite and relevant integration/build checks.
3. Check assets, permissions, platform configuration, and environment values.
4. Review dependency changes and generated output.
5. Produce a short release note and rollback plan.
6. Verify that failure telemetry is actionable and privacy-safe.

## Common mistakes

- Treating a green local test run as a release check.
- Shipping a development endpoint or secret.
- Adding analytics without a privacy purpose.
- Logging full exceptions that contain personal data.
- Changing CI to hide failures instead of fixing them.
