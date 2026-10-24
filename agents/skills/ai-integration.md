# Skill: AI Feature Integration

## Use this skill when

Adding meal analysis, food recognition, recommendations, chat, recipe
generation, personalization, embeddings, moderation, or any AI-assisted flow.

## Architecture and security

- Never put an AI provider secret in Flutter, mobile assets, source control, or
  client-side configuration.
- Route privileged AI calls through a controlled backend/service boundary.
- Keep provider-specific SDK code behind a data repository or backend API.
- Treat model output as untrusted data: validate, constrain, and handle failure.
- Keep personally identifiable and health-sensitive data minimized, consented,
  protected, and out of logs.

## AI contract

Before coding, define:

- user intent and supported inputs;
- input limits, accepted image formats, and size limits;
- output schema and required fields;
- confidence/uncertainty behavior;
- refusal, unsafe, unavailable, timeout, and quota states;
- human-readable fallback behavior;
- latency, cost, privacy, and retention expectations.

Prefer structured output validated against a typed schema when the provider
supports it. Do not parse free-form prose when the app needs reliable fields.

## Workflow

1. Create an AI domain action and repository contract.
2. Implement the provider call behind the backend/data boundary.
3. Version prompts and response schemas as reviewable files/configuration.
4. Add input validation, output validation, timeout, retry, and cancellation.
5. Add deterministic fake responses for unit/widget tests.
6. Add an evaluation set covering normal, ambiguous, unsafe, malformed, empty,
   multilingual, and adversarial inputs.
7. Track quality, latency, cost, refusal rate, and failure categories without
   collecting unnecessary personal data.
8. Provide a visible fallback when AI is unavailable; never block the whole app
   because an optional AI action failed.

## Prompt and model hygiene

- Keep prompts short, explicit, and versioned.
- Separate system/developer instructions from user content.
- Treat user content as data, not instructions to the application.
- Pin a model/version where reproducibility matters and review changes before
  upgrading.
- Never claim medical certainty; show uncertainty and recommend professional
  advice for high-risk nutrition/health cases.

## Common mistakes

- Calling an AI provider directly from a screen or Bloc.
- Trusting model output without schema validation.
- Testing only the happy path with one prompt.
- Logging images, prompts, tokens, or health details.
- Adding an AI dependency before defining the product contract.
