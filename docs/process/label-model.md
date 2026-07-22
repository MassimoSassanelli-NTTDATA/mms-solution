# Label Model & Status Automation

GitHub Issues are the operational backbone of the development process. Every epic,
story and task is a GitHub Issue, and its position in the process is tracked with
`status:*` labels. `STORY_INDEX.md` remains a derived, agent-maintained view;
GitHub Issues, Sub-Issues and PRs stay the source of truth.

## Label groups

The canonical catalog lives in [`.github/labels.yml`](../../.github/labels.yml) and
is applied to the platform repository and all code repositories by the
**Sync Labels** workflow.

| Group | Labels | Rule |
|---|---|---|
| `status:*` | idea, for-refinement, refined, ready, in-progress, blocked, in-review, validated, done | Exactly **one** active per issue (enforced) |
| `type:*` | epic, story, task | Set by the issue template / task creation |
| `repo:*` | mms-app, maui-toolkit, net-client-api | Owning code repository of a task |
| `priority:*` | p0–p3 | Optional |
| `area:*` | api, ui, sync, infra, docs | Optional |

## Status flow

```text
idea → for-refinement → refined → ready → in-progress → in-review → validated → done
                     ↘ blocked ↗ (from/return to active states)
```

Allowed transitions (enforced by the **Issue Status Guard**):

| From | Allowed next |
|---|---|
| `status:idea` | for-refinement, blocked |
| `status:for-refinement` | idea, refined, blocked |
| `status:refined` | ready, idea, blocked |
| `status:ready` | in-progress, refined, blocked |
| `status:in-progress` | in-review, ready, blocked |
| `status:blocked` | ready, in-progress, refined |
| `status:in-review` | validated, in-progress, blocked |
| `status:validated` | done, in-progress |
| `status:done` | — (terminal) |

Invalid label changes are automatically reverted with an explanatory comment.

## Workflows

| Workflow | Trigger | Purpose | Token |
|---|---|---|---|
| [`sync-labels.yml`](../../.github/workflows/sync-labels.yml) | dispatch / push to `labels.yml` | Apply the catalog to all repositories | `MULTI_REPO_TOKEN` |
| [`create-tasks-from-story.yml`](../../.github/workflows/create-tasks-from-story.yml) | dispatch | Create task issues in code repos, link as sub-issues, set story → `refined` | `MULTI_REPO_TOKEN` |
| [`issue-status-guard.yml`](../../.github/workflows/issue-status-guard.yml) | issue `labeled` | Enforce single status + valid transitions | `GITHUB_TOKEN` |
| [`story-status-rollup.yml`](../../.github/workflows/story-status-rollup.yml) | dispatch / hourly | Derive story status from its task sub-issues | `MULTI_REPO_TOKEN` |
| [`pr-task-status.yml`](../../.github/workflows/pr-task-status.yml) | `workflow_call` from code repos | PR open → task `in-review`, PR merged → task `done` | `GITHUB_TOKEN` |

## Lifecycle end to end

1. **discover-story** → a Story issue is created from the template with
   `type:story` + `status:idea`.
2. **Manual** → User moves the story to `status:for-refinement` (no automation).
3. **refine-story** → Agent verifies story is in `status:for-refinement`, then runs
   **Create Tasks From Story** workflow. Tasks are created in the code repositories
   (`type:task`, `status:ready`), linked as sub-issues. Story moves to `status:refined`
   with `repo:<name>` labels for each affected repository.
4. **start-task** → set the task to `status:in-progress` and open a PR that
   references the task with `Closes #<task>`.
5. PR opened → **PR Task Status** sets the task to `status:in-review`.
6. PR merged → the task moves to `status:done`.
7. **Story Status Rollup** derives the story status; once all tasks are done the
   story becomes `status:validated`.
8. **validate-story** → after validation the story is set to `status:done`.

### `Create Tasks From Story` input example

Write the tasks array to a JSON file and pass the file to the `tasks_json` input
(`-F` reads the file content raw, avoiding shell quoting issues):

```json
[
  { "repo": "net-client-api", "title": "Add work-order client", "body": "Refit client for /workorders", "priority": "p2", "labels": ["area:api"] },
  { "repo": "mms-app", "title": "Work-order list screen", "body": "CollectionView bound to work orders", "priority": "p2", "labels": ["area:ui"] }
]
```

```bash
gh workflow run create-tasks-from-story.yml -f story_issue_number=<n> -F tasks_json=@tasks.json
```

### Enabling PR-based task status in a code repository

Add this caller workflow to each code repository (`mms-app`, `maui-toolkit`,
`net-client-api`):

```yaml
# .github/workflows/pr-task-status.yml
name: PR Task Status
on:
  pull_request:
    types: [opened, reopened, ready_for_review, closed]
jobs:
  status:
    uses: MassimoSassanelli-NTTDATA/mms-solution/.github/workflows/pr-task-status.yml@main
    secrets: inherit
```

## Prerequisites

- **`MULTI_REPO_TOKEN`** secret must be present on the platform repository with
  `issues:write` (and read) scope on all code repositories. It is already used by
  the setup and validation workflows.
- The organization must have **sub-issues** enabled (already used by
  `story-index-validation.yml`).
