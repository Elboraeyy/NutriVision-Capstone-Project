# Stage 05 Test: AI Quality and Safety

## Evaluation cases

- [ ] Normal valid input.
- [ ] Ambiguous or low-confidence input.
- [ ] Empty or unsupported input.
- [ ] Malformed provider response.
- [ ] Timeout, quota, rate limit, and provider outage.
- [ ] Unsafe or disallowed request.
- [ ] Prompt injection or instruction-confusion input.
- [ ] Arabic/multilingual input when supported.
- [ ] High-risk nutrition/health case with uncertainty and safe escalation.

## Output contract

- [ ] Response is schema-validated before rendering.
- [ ] Missing fields have safe defaults or produce a controlled failure.
- [ ] User-facing text does not claim medical certainty.
- [ ] Fallback UI works when AI is unavailable.

## Measurement

- [ ] Quality/evaluation set is versioned.
- [ ] Latency and cost expectations are recorded.
- [ ] Sensitive prompts/images are not stored in test artifacts.
