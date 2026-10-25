# Integration tests

Put end-to-end journeys here once real app wiring exists. Start with:

- authentication and onboarding;
- adding a meal and viewing its history;
- nutrition lookup failure and retry;
- AI analysis success, timeout, quota, and unavailable fallback.

Keep fast unit, Bloc, and widget tests under `test/`. Do not add credentials or
production user data to integration fixtures.
