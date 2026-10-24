# Agent Task Template: Code Review

Copy this prompt when asking an AI agent to review a change:

```text
Read AGENTS.md, ARCHITECTURE.md, and agents/skills/testing-verification.md.
Review the requested diff for correctness and architecture compliance.

Review scope: <commit, branch, or files>
User story: <intended behavior>

Check especially:
- Clean Architecture dependency direction.
- Repository/use-case boundaries.
- Bloc versus Cubit choice and immutable states.
- Navigation and one-time side effects.
- AppToast usage and validation/failure feedback.
- Responsive UI and existing visual language.
- Tests, error paths, and regressions.
- Secrets, generated files, and unrelated changes.

Report findings by priority with exact file paths and line numbers. If there
are no findings, say so and list the checks performed.
```
