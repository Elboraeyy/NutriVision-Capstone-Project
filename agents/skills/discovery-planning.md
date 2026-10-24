# Skill: Discovery and Implementation Planning

## Use this skill when

Starting a feature, integration, redesign, bug fix, refactor, or any request
whose scope is not already explicit.

## Required output before coding

Write a short plan containing:

- user outcome and affected persona;
- acceptance criteria written as observable behavior;
- in-scope and out-of-scope work;
- affected feature(s), routes, domain entities, repositories, and state;
- existing widgets/helpers that can be reused;
- loading, empty, error, validation, offline, and unavailable states;
- security/privacy risks and external dependencies;
- test files that must be created or updated;
- rollback or migration concerns.

## Workflow

1. Inspect the relevant source, tests, router, composition root, and assets.
2. Search for existing behavior before introducing a new abstraction.
3. Map the request to the smallest feature boundary.
4. Choose Bloc versus Cubit before writing state code.
5. Define domain contracts before choosing a backend implementation.
6. Create the stage test plan under `agents/tests/`.
7. Implement only after the plan exposes no unresolved architecture decision.

## Definition of ready

A task is ready for implementation when the agent can answer: what changes,
where the change belongs, how success/failure are visible, and how the change
will be tested.

## Common mistakes

- Starting with a widget before understanding the data flow.
- Treating a vague feature name as acceptance criteria.
- Adding dependencies before checking existing packages.
- Ignoring empty, offline, permission, or failure states.
- Planning a new global manager for a feature-local problem.
