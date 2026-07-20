# Repository Context Aggregation

## Purpose

Each sub-repository owns its own implementation instructions, skills, ADRs, build commands and test commands.

The platform repository does not duplicate those rules. It references them through `.github/copilot-platform.json`.

At runtime, the setup workflow generates `REPOSITORY_CONTEXT.md` from the `context` sections of the manifest.

## Required Rule

Agents must read `REPOSITORY_CONTEXT.md` before refinement, implementation orchestration, story validation or task implementation.

## Conflict Resolution

- Platform manifest decides orchestration, ownership, issue hierarchy and dependency direction.
- Target repository instructions decide implementation conventions.
- Accepted ADRs override older guidance.

## Runtime Files

`REPOSITORY_CONTEXT.md` is generated and must not be committed.
