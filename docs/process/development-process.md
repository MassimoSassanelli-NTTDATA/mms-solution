# Agentic Development Process

```text
discover-story        (Story issue: type:story, status:idea)
  -> refine-story      (Create Tasks From Story -> tasks + sub-issues, story status:refined)
  -> create task issues
  -> attach tasks as sub-issues
  -> create story branch
  -> start-story
  -> start-task        (task status:in-progress -> PR -> status:in-review)
  -> validate-story    (all tasks done -> story status:validated -> status:done)
  -> review
  -> merge             (task status:done)
```

Status is tracked with `status:*` labels on the GitHub issues and largely
automated. See [label-model.md](label-model.md) for the label catalog, allowed
transitions and the workflows that drive them.

Agents must read `WORKSPACE.md` and `REPOSITORY_CONTEXT.md` when available.
