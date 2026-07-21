# Repository Context Aggregation

## Purpose

Each sub-repository owns its own implementation instructions, skills, ADRs, build commands and test commands.

The platform repository references repository-owned context through `.github/copilot-platform.json`.
Sub-repository skills are additionally mirrored into `.github/skills` with the `_subrepo_` prefix by `scripts/sync-subrepo-skills.ps1` (usually triggered via Git hook).

At runtime, the setup workflow generates `REPOSITORY_CONTEXT.md` from the `context` sections of the manifest.

## Required Rule

Agents must read `REPOSITORY_CONTEXT.md` before refinement, implementation orchestration, story validation or task implementation.

## Conflict Resolution

- Platform manifest decides orchestration, ownership, issue hierarchy and dependency direction.
- Target repository instructions decide implementation conventions.
- Accepted ADRs override older guidance.

## Runtime Files

`REPOSITORY_CONTEXT.md` is generated and must not be committed.
