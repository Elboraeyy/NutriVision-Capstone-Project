# NutriVision Agent Resources

This folder is the operating system for AI agents and team members working on
NutriVision. It contains reusable project skills, task templates, stage-by-stage
test plans, quality gates, and an index of the repository's existing agent
instructions.

## Required agent lifecycle

Every meaningful task follows this sequence:

1. **Discover:** read `AGENTS.md`, `ARCHITECTURE.md`, the relevant skill, and
   the existing implementation before editing.
2. **Plan:** write the user outcome, acceptance criteria, architecture impact,
   reuse opportunities, risks, and test plan.
3. **Design:** decide the feature boundaries, state owner, data contract, UI
   composition, and error/empty/loading states.
4. **Build:** implement through domain contracts and use cases, then wire the
   presentation layer through the composition root.
5. **Test:** create or update the applicable file under `tests/` and the real
   executable tests under the repository's `test/` directory.
6. **Audit:** run the architecture, duplication, security, accessibility, and
   regression checks before handoff.
7. **Handoff:** report changed files, checks, limitations, and follow-up work.

If an existing change violates the architecture, the agent should repair the
violation in the smallest safe way, add a regression test, and document the
repair. Do not preserve an architectural violation merely because it was
introduced by another team member.

## Contents

| Path | Purpose |
| --- | --- |
| [`manifest.md`](manifest.md) | Inventory of all existing agent-facing files and their canonical locations. |
| [`skills/flutter-feature.md`](skills/flutter-feature.md) | Add a feature using Clean Architecture. |
| [`skills/discovery-planning.md`](skills/discovery-planning.md) | Turn a request into acceptance criteria and an implementation plan. |
| [`skills/state-management.md`](skills/state-management.md) | Choose and implement Bloc or Cubit correctly. |
| [`skills/ui-implementation.md`](skills/ui-implementation.md) | Implement UI using NutriVision's design system. |
| [`skills/design-system.md`](skills/design-system.md) | Extend the visual system without duplicating styles or widgets. |
| [`skills/forms-validation.md`](skills/forms-validation.md) | Build consistent, accessible, testable forms and validation. |
| [`skills/backend-repository.md`](skills/backend-repository.md) | Add or replace a data source behind repository contracts. |
| [`skills/api-integration.md`](skills/api-integration.md) | Design resilient API contracts, mapping, errors, and retries. |
| [`skills/ai-integration.md`](skills/ai-integration.md) | Integrate AI safely through a backend boundary with evals. |
| [`skills/data-persistence.md`](skills/data-persistence.md) | Add local storage, caching, migrations, and offline behavior. |
| [`skills/navigation-auth.md`](skills/navigation-auth.md) | Work with routes, auth, and onboarding transitions. |
| [`skills/security-privacy.md`](skills/security-privacy.md) | Protect secrets, PII, prompts, tokens, and user data. |
| [`skills/performance-accessibility.md`](skills/performance-accessibility.md) | Review performance, responsive behavior, and accessibility. |
| [`skills/localization-rtl.md`](skills/localization-rtl.md) | Prepare English/Arabic strings, RTL, and text resilience. |
| [`skills/dependency-maintenance.md`](skills/dependency-maintenance.md) | Add, upgrade, and review packages safely. |
| [`skills/testing-verification.md`](skills/testing-verification.md) | Test and verify a change before handoff. |
| [`skills/architecture-audit-refactor.md`](skills/architecture-audit-refactor.md) | Detect and repair drift, duplication, and layer violations. |
| [`skills/release-ci-observability.md`](skills/release-ci-observability.md) | Prepare CI, release checks, logging, metrics, and rollback plans. |
| [`skills/git-collaboration.md`](skills/git-collaboration.md) | Work safely with branches, merges, and pull requests. |
| [`skills/documentation-handoff.md`](skills/documentation-handoff.md) | Keep docs and agent handoffs useful and synchronized. |
| [`tests/README.md`](tests/README.md) | Stage-by-stage test artifacts and quality gates. |
| [`templates/feature-task.md`](templates/feature-task.md) | Prompt template for implementing a new feature. |
| [`templates/bug-fix-task.md`](templates/bug-fix-task.md) | Prompt template for diagnosing and fixing a bug. |
| [`templates/review-task.md`](templates/review-task.md) | Prompt template for reviewing a change. |

## Canonical paths that must remain in place

The files below are intentionally kept in their standard locations because
different tools discover them automatically there. Do not move them into this
folder:

- `AGENTS.md` — repository-wide rules for coding agents.
- `.agents/rules/nutrivision.md` — Antigravity workspace rule that loads the
  canonical instructions and this resource library.
- `.cursor/rules/nutrivision-project.mdc` — Cursor rules.
- `.windsurf/rules/nutrivision-project.md` — Windsurf rules.
- `.github/copilot-instructions.md` — GitHub Copilot instructions.
- `CLAUDE.md` — Claude project instructions.
- `GEMINI.md` — Gemini project instructions.

Antigravity supports `AGENTS.md`, `GEMINI.md`, and workspace rules under
`.agents/rules/`; the repository uses all three only as compatible entry points
to the same canonical rules.

Their inventory and relationship to this folder are documented in
[`manifest.md`](manifest.md).

## Universal completion checklist

Before declaring a task complete, an agent must confirm:

- the change follows `AGENTS.md` and `ARCHITECTURE.md`;
- business logic is not inside widgets;
- repositories are not called directly from screens;
- no duplicate state source was introduced;
- feedback uses `AppToast` when short-lived feedback is actually needed;
- routes use the centralized `go_router` configuration;
- `dart format .` completed;
- `flutter analyze` completed without issues;
- `flutter test` passed, or failures are clearly reported;
- no secrets, generated output, or personal IDE settings were added;
- unrelated user changes remain untouched.

## Adding a new project skill

Add a focused Markdown file under `agents/skills/` when a repeated project
workflow needs its own instructions. A skill should contain:

1. When to use it.
2. Non-negotiable rules.
3. A short implementation workflow.
4. Verification steps.
5. Common mistakes to avoid.

Keep skills specific to NutriVision and link them from this file.

## Reuse and DRY policy

Before writing a new widget, helper, validator, mapper, API error type, or
formatting function, search the existing code and `lib/core/`. If the behavior
is used or likely to be used by more than one feature, extract a small typed
reusable component in the correct shared location. Avoid speculative generic
frameworks; reuse should reduce duplication without hiding feature intent.

## Official reference links

These are living references for practices that change over time:

- [Flutter app architecture](https://docs.flutter.dev/app-architecture)
- [Flutter architecture recommendations](https://docs.flutter.dev/app-architecture/recommendations)
- [Flutter testing overview](https://docs.flutter.dev/testing/overview)
- [OpenAI API reference and security guidance](https://platform.openai.com/docs/api-reference)
