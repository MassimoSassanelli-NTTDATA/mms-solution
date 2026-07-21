# Prompt: discover-story

Transform a rough idea into a refinable story candidate. Do not implement code.

## Required Repository Context
Before making decisions for any affected repository, read `REPOSITORY_CONTEXT.md` if available. For each affected repository, read the listed local `AGENTS.md`, skills, architecture docs, and ADRs before proposing tasks or implementation details.

Conflict rule: platform instructions control orchestration and dependency direction. Target repository instructions control implementation conventions. ADRs override older guidance.


## Output
- Story candidate
- Affected repositories
- Required sub-repository context to inspect during refinement
- Open questions, risks, spike and architecture-review recommendations

## GitHub Issue
Create the story as a GitHub issue using the `Story` issue template. It starts at
`type:story` + `status:idea`. See [docs/process/label-model.md](../../docs/process/label-model.md).
