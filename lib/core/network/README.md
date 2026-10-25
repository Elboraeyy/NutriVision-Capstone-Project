# Core network

This folder is reserved for generic transport concerns:

- HTTP client configuration and timeouts.
- Request cancellation and bounded retry policy.
- Authentication and correlation interceptors.
- Safe redacted logging.
- Common response and status-code mapping.

Feature endpoints, DTOs, mappers, and repository implementations belong in the
feature's `data/` layer. Never place API keys or provider-specific business
logic here.
