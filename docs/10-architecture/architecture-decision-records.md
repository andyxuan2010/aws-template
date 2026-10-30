# Architecture Decision Records

Architecture Decision Records (ADRs) preserve the reasoning behind choices that affect multiple modules, consumers, security boundaries, or operations. This guide defines how to add an ADR; it does not reconstruct undocumented historical discussions.

## Current architectural constraints

- This repository is a reusable module catalog with an example composition, not a permanently deployed environment.
- The consuming root owns providers, credentials, account and Region selection, backend state, and apply lifecycle.
- GitHub Actions and Azure DevOps validate Terraform without AWS credentials or remote state. Neither pipeline applies resources.
- Optional GitHub and Azure DevOps publishers distribute repository content; they do not deploy to AWS.
- A catalog module is not automatically enabled in a consumer's root composition.

See [Repository Architecture](repository-architecture.md), [Foundation Composition Guide](../20-repository/foundation-composition-guide.md), and [Environment and Delivery Lifecycle](../30-deployment/environment-lifecycle.md) for current details.

## When to write an ADR

Write an ADR when a decision changes a shared module interface, platform dependency, identity or trust model, network boundary, state strategy, promotion path, security control, or support responsibility. Module-local implementation details belong in the module README unless they affect other consumers.

## ADR template

Create a numbered Markdown file under `docs/90-decisions/`, for example `docs/90-decisions/0001-shared-network-boundary.md`:

```markdown
# ADR 0001: <short decision title>

- Status: proposed | accepted | superseded | rejected
- Decision owners: <team or roles>
- Date: YYYY-MM-DD

## Context
What problem or constraint requires a decision?

## Decision
What choice was made, and where does it apply?

## Alternatives considered
List realistic alternatives and why they were not selected.

## Consequences
Describe benefits, costs, risks, migration, and operational responsibilities.

## Evidence and links
Link to implementation, security review, or approved design record.
```

## Review and lifecycle

Ask the platform and security owners to review decisions that affect their domains. Link accepted ADRs from relevant architecture and module guides. Do not silently rewrite an accepted decision: mark it superseded and create a new ADR with the migration path.
