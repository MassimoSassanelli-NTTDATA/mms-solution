# Prompt: validate-story

Validate a complete story across all participating repositories before PR approval.

## Required Repository Context
Before making decisions for any affected repository, read `REPOSITORY_CONTEXT.md` if available. For each affected repository, read the listed local `AGENTS.md`, skills, architecture docs, and ADRs before proposing tasks or implementation details.

Conflict rule: platform instructions control orchestration and dependency direction. Target repository instructions control implementation conventions. ADRs override older guidance.


Validation must include branch alignment, build/test checks, acceptance criteria coverage, sub-issue synchronization and repository-specific rule compliance.
