# Story Index Synchronization

GitHub Issues, Sub-Issues, Pull Requests and validation reports are the source of truth.

`STORY_INDEX.md` exists primarily for agents. It is a compact synchronized view.

Refinement must attach tasks as sub-issues to the parent platform story.
Sync must reconcile `STORY_INDEX.md` against actual GitHub sub-issues.
If there is a mismatch, GitHub wins.

## Persistence and Commit Policy

`STORY_INDEX.md` is a **committed, versioned file** in the platform repository. It is not a runtime artifact and is not listed in `.gitignore` (unlike `REPOSITORY_CONTEXT.md`, which must not be committed).

- **It is never the source of truth.** It is a derived, synchronized view of GitHub Issues, Sub-Issues, Pull Requests and validation reports.
- **Only agents write it, and only via the defined steps:**
  - `refine-story` adds or updates rows once task links and sub-issue status are known.
  - `sync-story` reconciles it against the actual GitHub sub-issues and repairs any drift.
- **It is committed as part of the story/PR flow** on the platform repository, in the same change set that established or updated the corresponding GitHub issues. Manual, out-of-band edits should be avoided.
- **Conflict resolution:** on any merge conflict or divergence, GitHub wins. Do not hand-merge conflicting rows; re-run `sync-story` to regenerate the affected rows from the authoritative GitHub state.
