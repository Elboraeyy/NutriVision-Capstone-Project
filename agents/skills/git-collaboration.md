# Skill: Git Collaboration

## Use this skill when

Creating a branch, preparing a commit, merging work, resolving conflicts, or
handing changes to another team member or agent.

## Rules

- Start with `git status --short --branch`.
- Preserve unrelated user changes, including untracked files.
- Use focused commits with imperative messages such as `feat:`, `fix:`,
  `docs:`, or `refactor:`.
- Do not use destructive reset/checkout commands to discard work.
- Review the diff before committing.
- Never commit secrets, credentials, build output, or personal IDE settings.
- Prefer the repository's existing branch conventions; use `codex/` for new
  agent-created branches unless the team requests another name.
- Do not force-push unless the owner explicitly requests it.

## Safe workflow

```bash
git status --short --branch
git fetch origin
git diff --check
git diff --stat
# edit and verify
git add <intended-files>
git diff --cached --check
git commit -m "type: short imperative message"
git push origin <branch>
```

For a merge:

1. Confirm the target branch and source branch.
2. Fetch the latest remote refs.
3. Check for local changes and preserve them.
4. Merge the source branch into the target branch.
5. Resolve conflicts by combining intent, not by blindly choosing a side.
6. Run format/analyze/test after conflict resolution.
7. Review the merge diff and push only the intended target branch.

## Common mistakes

- Staging every file with `git add .` when unrelated changes exist.
- Overwriting a user's untracked configuration file.
- Merging stale remote refs.
- Pushing a feature branch when the requested target is `main`.
- Treating a successful commit as proof that tests pass.
