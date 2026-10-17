# Claude project instructions

The canonical project instructions are in [AGENTS.md](AGENTS.md). Read and
follow that file completely before making changes. Do not create a conflicting
set of architecture or styling rules here.

In particular, preserve the project's Clean Architecture, use real Bloc for
feature workflows, Cubit only for small local state, register repositories with
`MultiRepositoryProvider`, keep screens thin, and run `dart format .`,
`flutter analyze`, and `flutter test` before finishing.
