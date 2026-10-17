# Claude project instructions

The canonical project instructions are in [AGENTS.md](AGENTS.md). Read and
follow that file completely before making changes. Do not create a conflicting
set of architecture or styling rules here.

In particular, preserve the project's Clean Architecture, use real Bloc for
feature workflows, Cubit only for small local state, register repositories with
`MultiRepositoryProvider`, keep screens thin, and run `dart format .`,
`flutter analyze`, and `flutter test` before finishing. When adding a feature,
use contextual `AppToast` feedback only for meaningful success, failure,
validation blockers, or unavailable actions; do not add redundant toasts for
normal navigation or visible state changes.
