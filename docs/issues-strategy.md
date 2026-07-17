# GitHub Issues Strategy

## Platform Repository

Use the platform repository for:

- Epics
- Stories
- Cross-repository analysis
- Architecture decisions
- Product-level acceptance criteria
- Discovery notes

## Code Repositories

Use code repositories for:

- implementation tasks
- bugs
- technical refactorings
- repository-specific acceptance criteria
- PRs and code reviews

## Recommended Flow

```text
Epic in mobile-service-platform
  -> Story in mobile-service-platform
    -> Task in mobile-service-app
    -> Task in maui-toolkit
    -> Task in net-client-api
    -> Task in offline-sync-sdk
```

## Story Template

```markdown
# Story: <title>

## Goal

## User Value

## Scope

## Affected Repositories

- [ ] mobile-service-app
- [ ] maui-toolkit
- [ ] net-client-api
- [ ] offline-sync-sdk

## Acceptance Criteria

## Implementation Tasks

- [ ] <repo>: <task title>
```
