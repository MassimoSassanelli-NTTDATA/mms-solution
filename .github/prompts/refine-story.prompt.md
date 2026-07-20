# Prompt: refine-story

Refine a story candidate into a ready implementation story and repository-specific tasks.

## Required Repository Context
Before making decisions for any affected repository, read `REPOSITORY_CONTEXT.md` if available. For each affected repository, read the listed local `AGENTS.md`, skills, architecture docs, and ADRs before proposing tasks or implementation details.

Conflict rule: platform instructions control orchestration and dependency direction. Target repository instructions control implementation conventions. ADRs override older guidance.


## Mandatory Steps
1. Read `WORKSPACE.md` and `REPOSITORY_CONTEXT.md`.
2. For each affected repository, read declared local instructions, skills, architecture docs and ADRs.
3. Create task issue drafts in target repositories.
4. Attach or instruct how to attach every task as a GitHub sub-issue of the parent story.
5. Update `STORY_INDEX.md` as a synchronized agent view only after task links and sub-issue status are known.

## Output
- Ready story
- Task breakdown per repository
- Sub-issue attachment plan
- Story index update
- Context files read per repository
