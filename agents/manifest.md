# Agent File Manifest

This manifest prevents agent instructions from being lost across editors and
AI tools. The central resources live in `agents/`, while tool-specific files
remain at their discovery paths.

## Repository-wide references

| File | Role | Canonical source |
| --- | --- | --- |
| `AGENTS.md` | Full coding-agent rules and project context. | Yes |
| `ARCHITECTURE.md` | Detailed Clean Architecture and feature workflow guide. | Yes |
| `README.md` | Project overview, features, technologies, and links. | Yes |
| `docs/architecture.md` | Short architecture overview for project documentation. | Summary |
| `CONTRIBUTING.md` | Contribution conventions. | Yes |

## Tool-specific agent files

These files are agent-facing but must stay where their tools expect them:

```text
.agents/rules/nutrivision.md
.cursor/rules/nutrivision-project.mdc
.windsurf/rules/nutrivision-project.md
.github/copilot-instructions.md
CLAUDE.md
GEMINI.md
```

If a rule changes, update the canonical repository rules first and then keep
the tool-specific file aligned with them.

## Central skills

```text
agents/
  README.md
  manifest.md
  skills/
    backend-repository.md
    architecture-audit-refactor.md
    api-integration.md
    ai-integration.md
    data-persistence.md
    design-system.md
    dependency-maintenance.md
    discovery-planning.md
    documentation-handoff.md
    forms-validation.md
    flutter-feature.md
    git-collaboration.md
    navigation-auth.md
    performance-accessibility.md
    release-ci-observability.md
    security-privacy.md
    state-management.md
    testing-verification.md
    ui-implementation.md
    localization-rtl.md
  tests/
    README.md
    quality-gates.md
    features/README.md
    stages/
      01-discovery-test.md
      02-architecture-test.md
      03-ui-test.md
      04-data-api-test.md
      05-ai-test.md
      06-integration-test.md
      07-release-test.md
  templates/
    ai-integration-task.md
    architecture-audit-task.md
    api-integration-task.md
    bug-fix-task.md
    feature-task.md
    project-lifecycle-task.md
    review-task.md
```

## Recommended reading order

```text
AGENTS.md
  ↓
ARCHITECTURE.md
  ↓
agents/skills/<task-specific-skill>.md
  ↓
feature source + tests + router/composition root
```
