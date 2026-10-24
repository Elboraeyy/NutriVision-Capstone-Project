# Skill: Dependency and SDK Maintenance

## Use this skill when

Adding a package, upgrading Flutter/Dart, changing a plugin, or reviewing a
security/advisory-related dependency change.

## Rules

- Prefer the stable Flutter channel for team and release work.
- Check whether the SDK or existing package already solves the problem before
  adding a dependency.
- Review package ownership, license, platform support, transitive dependencies,
  maintenance activity, and security implications.
- Keep `pubspec.yaml` and `pubspec.lock` changes intentional and reviewable.
- Do not upgrade unrelated packages in the same feature change.
- Run formatting, analyze, tests, and relevant builds after an upgrade.

## Workflow

1. Record the reason and expected benefit of the dependency change.
2. Inspect current SDK/package constraints and compatibility.
3. Add the smallest compatible version range.
4. Review the lockfile diff and transitive packages.
5. Run the full verification suite and feature tests.
6. Document migration or rollback steps when behavior changes.
