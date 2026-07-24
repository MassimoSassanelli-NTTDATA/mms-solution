# Prompt: start-task

Implement exactly one ready task in the current code repository.

## Required Repository Context
Before making decisions for any affected repository, read `REPOSITORY_CONTEXT.md` if available. For each affected repository, read the listed local `AGENTS.md`, skills, architecture docs, and ADRs before proposing tasks or implementation details.

Conflict rule: platform instructions control orchestration and dependency direction. Target repository instructions control implementation conventions. ADRs override older guidance.

Prioritize the current repository's local `AGENTS.md`, skills, ADRs and docs over platform-level implementation assumptions.

## Branch Strategy

Every task belongs to a parent Story. Before touching any branch:

1. Read the task issue from GitHub to find its parent Story number and title.
   Derive the **shared branch name**:
   ```
   story/<story-number>-<slug>
   ```
   The slug is the story title lowercased, spaces replaced by hyphens, special
   characters removed (max 50 characters). This matches the convention in
   [`docs/process/story-branching-strategy.md`](../../docs/process/story-branching-strategy.md).

2. In the **code repository** of this task, check whether the branch already exists:
   ```powershell
   git ls-remote --heads origin "story/<story-number>-<slug>"
   ```
   - Branch **exists** → check it out. Do **not** create a new one.
   - Branch **does not exist** → create it from `main`.

3. All tasks of the same Story in the **same repository** share this single branch.
   Multiple tasks accumulate commits on it.

## Pull Request Strategy – One PR per Repository per Story

Open at most **one PR per repository per Story**, not one PR per task:

1. Before opening a PR, check whether one for this branch already exists:
   ```powershell
   gh pr list --repo <owner>/<repo> --head "story/<story-number>-<slug>" --state open
   ```

2. **PR already exists** → add `Closes #<task-number>` to the PR body via
   `gh pr edit --body-file` (append; do **not** open a new PR).

3. **No PR exists yet** → open a new PR:
   - Head: `story/<story-number>-<slug>` → Base: `main`
   - Title: `[Story #<story-number>] <story-title>`
   - Body: one `Closes #<task-number>` line per task of this Story that lives in
     this repository (query open tasks of the same Story for this repo and include
     all their `Closes` references upfront).

The **PR Task Status** workflow advances tasks from `in-review` → `done` on PR merge
using the `Closes` references in the PR body.

## Root Repository Gate PR

When the story branch does not yet exist in the **platform repository** (root of the
multi-repo workspace, `MMS`):

1. In the platform repository, create branch `story/<story-number>-<slug>` from `main`.
2. Commit a story tracking file on that branch:
   ```
   stories/active/<story-number>-<slug>.md
   ```
   The file contains: story title, story issue link, and a checklist of **all**
   sub-tasks across all repositories (repo name, task number, task title).
3. Open one PR in the platform repository:
   - Title: `[Story #<story-number>] <story-title>`
   - Base: `main`
   - Body:
     ```
     Relates to #<story-number>

     ## Sub-Tasks

     Merge only after all sub-tasks have `status:done`.

     - [ ] `<repo-1>` #<task-A> – <task-A-title>
     - [ ] `<repo-2>` #<task-B> – <task-B-title>
     ```

4. If the root PR already exists, append any missing task lines to the checklist.

The root PR **must not be merged** before all checklist items are ticked (all
sub-tasks `status:done`).

## Cross-Repository Interface Check

Wenn der Task-Body einen Abschnitt `### Cross-Repository Interface` enthält,
prüfe **vor** der Umsetzung den `Contract-Status` des referenzierten
Producer-Tasks (siehe [docs/process/task-orchestration.md](../../docs/process/task-orchestration.md)):

- `draft`: Stoppe die Umsetzung und melde den Blocker. Consumer dürfen erst ab
  `frozen` starten.
- `frozen`: Implementierung gegen den dokumentierten Contract ist erlaubt. Der
  finale Merge kann jedoch auf `released` warten (z. B. NuGet-Publish).
- `released`: Keine Einschränkung; Umsetzung und Merge sind möglich.

## Status Labels
Move the task to `status:in-progress` when you start. The `Closes #<task-number>`
references in the PR body drive the **PR Task Status** workflow: PR opened →
`status:in-review`, PR merged → `status:done`. See
[docs/process/label-model.md](../../docs/process/label-model.md).
