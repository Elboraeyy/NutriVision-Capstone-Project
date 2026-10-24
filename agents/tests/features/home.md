# Home Feature Test Plan

## Acceptance matrix

- [ ] Dashboard loading renders a non-blocking loading state.
- [ ] Successful dashboard data renders the nutrition card and sections.
- [ ] Repository failure renders a recoverable error state.
- [ ] Tab selection updates the active tab without duplicating dashboard data.
- [ ] Floating header and bottom navigation preserve the established layout.
- [ ] Unavailable actions communicate clearly without noisy toasts.

## Required executable coverage

- [x] Existing dashboard state test: `test/features/home_cubit_test.dart`.
- [ ] Repository success/failure tests.
- [ ] Bloc event tests for loading and tab selection.
- [ ] Widget tests for dashboard, loading, error, and tab states.
- [ ] Integration test for authenticated navigation into home.
