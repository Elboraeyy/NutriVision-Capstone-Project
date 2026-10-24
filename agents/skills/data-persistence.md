# Skill: Data Persistence, Cache, and Offline Behavior

## Use this skill when

Adding local storage, drafts, cache, secure preferences, offline behavior,
sync, migrations, or persistence for auth/onboarding/meal data.

## Rules

- Keep storage code in `data/`, behind the domain repository contract.
- Define ownership, lifetime, schema, migration, and deletion behavior before
  writing storage code.
- Separate cache data from source-of-truth server data.
- Do not store secrets or sensitive health data in plain preferences.
- Never let widgets know whether data came from cache, disk, or network.
- Make stale, empty, corrupt, and unavailable states explicit.

## Workflow

1. Classify the data: transient UI, draft, cache, durable user data, or secret.
2. Define serialization and versioned schema.
3. Define migration, logout cleanup, account deletion, and recovery behavior.
4. Implement a repository with in-memory/fake and real storage variants.
5. Add tests for first read, write/read round trip, corrupt data, migration,
   stale cache, offline mode, and deletion.
6. Expose domain entities, not storage records, to the presentation layer.

## Common mistakes

- Using `SharedPreferences` as a database for complex records.
- Treating cache as authoritative without a freshness policy.
- Forgetting logout/account deletion cleanup.
- Persisting tokens or health data without a security review.
- Adding storage calls to a widget lifecycle method.
