# Prompt: start-task

Implement exactly one ready task in the current code repository.

## Required Repository Context
Before making decisions for any affected repository, read `REPOSITORY_CONTEXT.md` if available. For each affected repository, read the listed local `AGENTS.md`, skills, architecture docs, and ADRs before proposing tasks or implementation details.

Conflict rule: platform instructions control orchestration and dependency direction. Target repository instructions control implementation conventions. ADRs override older guidance.


Prioritize the current repository's local `AGENTS.md`, skills, ADRs and docs over platform-level implementation assumptions.

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
Move the task to `status:in-progress` when you start. Open the pull request with a
closing reference (`Closes #<task-number>`) so the **PR Task Status** workflow can
move it to `status:in-review` and then `status:done` on merge. See
[docs/process/label-model.md](../../docs/process/label-model.md).
