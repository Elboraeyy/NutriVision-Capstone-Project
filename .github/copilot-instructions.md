# GitHub Copilot instructions

Before suggesting or editing code in this repository, read the root
`AGENTS.md` file and follow it as the canonical source of project rules.

Important requirements include Clean Architecture by feature, `Bloc<Event,
State>` for shared workflows, Cubit only for small local UI state,
`MultiRepositoryProvider` for repositories, thin screens, reusable widgets,
and passing `dart format .`, `flutter analyze`, and `flutter test`.
