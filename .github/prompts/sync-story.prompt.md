# Prompt: sync-story

Synchronize the platform story with GitHub Issues, Sub-Issues, implementation tasks, PRs, validation reports and `STORY_INDEX.md`.

## Required Repository Context
Before making decisions for any affected repository, read `REPOSITORY_CONTEXT.md` if available. For each affected repository, read the listed local `AGENTS.md`, skills, architecture docs, and ADRs before proposing tasks or implementation details.

Conflict rule: platform instructions control orchestration and dependency direction. Target repository instructions control implementation conventions. ADRs override older guidance.


GitHub Issues/Sub-Issues/PRs win over the index. Repair the index when mismatches are found.
