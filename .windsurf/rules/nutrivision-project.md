# NutriVision Windsurf rules

Read and follow the root `AGENTS.md` as the canonical project instruction file.
Do not introduce conflicting rules. Keep the established Clean Architecture,
Bloc/Cubit policy, RepositoryProvider composition root, reusable widgets,
floating UI design, contextual `AppToast` feedback only when a meaningful
success, failure, validation blocker, or unavailable action needs it, and the
verification commands described there. Avoid redundant toasts for normal
navigation or visible state changes.
