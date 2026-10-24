# Stage 04 Test: Data, API, and Persistence

## Contract cases

- [ ] Valid success response maps to domain entities.
- [ ] Empty response is distinct from failure.
- [ ] Malformed response is rejected safely.
- [ ] Validation/auth/permission/server/network failures are distinguishable.
- [ ] Timeout and cancellation behavior is defined.
- [ ] Retry applies only to safe operations and is bounded.
- [ ] Cache freshness, stale data, and offline behavior are defined.
- [ ] Logout/account deletion cleanup is defined for persisted data.

## Security cases

- [ ] No secret or token is in source, fixtures, or logs.
- [ ] Sensitive payloads are synthetic and redacted.
- [ ] API/provider credentials stay behind the backend boundary.

## Executable proof

- [ ] Fake repository tests success/failure/empty paths.
- [ ] Mapper tests valid, missing, and malformed fields.
- [ ] API adapter tests timeout, retry, auth expiry, and server failure.
- [ ] Persistence tests round trip, migration, corruption, and deletion.
