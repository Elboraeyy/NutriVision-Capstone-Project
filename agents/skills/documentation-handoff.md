# Skill: Documentation and Agent Handoff

## Use this skill when

Adding project documentation, updating architecture guidance, or preparing a
task for another team member or AI agent.

## Rules

- Keep code, identifiers, and file names in English.
- Keep architecture rules consistent with `AGENTS.md`.
- Link new guidance from `agents/README.md` or the relevant project README.
- Prefer concrete paths and examples over abstract statements.
- Document why a rule exists when the reason prevents a common mistake.
- Do not claim a check passed unless it was actually run.
- Mention intentionally omitted generated/build files in folder diagrams.

## Handoff format

Every handoff should include:

1. Outcome: what changed.
2. Files: the important paths changed.
3. Architecture: how the change follows the project layers.
4. Verification: exact commands and results.
5. Limitations: unresolved issues or follow-up work.
6. Working tree: whether unrelated changes remain.

## Common mistakes

- Updating a summary document while leaving the canonical rules contradictory.
- Writing instructions without naming the files where the work belongs.
- Adding a skill with no trigger condition or verification steps.
- Describing generated output as source code.
- Forgetting to update the skill index after adding a skill.
