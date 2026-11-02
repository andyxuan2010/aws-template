# Repository Architecture

## Purpose

This repository is the source for reusable AWS Terraform modules. It provides
module code, a five-module foundation example, mocked module tests, and CI
checks. It is not the stateful deployment root for an AWS account or landing
zone.

## Layers and ownership

| Layer | Responsibility | Owner |
| --- | --- | --- |
| Terraform modules | Manage a cohesive AWS capability and expose stable inputs and outputs. | This repository. |
| Foundation example | Show how networking, security groups, storage, IAM, and compute can be composed. | This repository, as an example only. |
| Consuming root | Configure providers, credentials, state, account/Region selection, and module versions or local sources. | The platform or workload team. |
| Account governance | Own Organizations, account vending, identity federation, SCPs, quotas, and organization-wide controls. | The AWS platform organization. |

Modules accept dependency IDs and values from the caller. They do not create an
implicit dependency graph across independent modules, configure a backend, or
apply resources from this repository's pipelines.

## Repository flow

1. A reviewed change updates Terraform, tests, or documentation.
2. GitHub Actions runs static checks, an offline foundation plan, and tests for
   changed modules. Azure Pipelines performs the offline plan and uses a
   changed-module matrix for its push builds.
3. Successful branch runs may publish repository snapshots or mirror Git
   history to configured destinations. Publishing is separate from AWS
   provisioning.
4. A consuming root selects an account and Region, configures state and AWS
   credentials, then plans and applies under its own approval controls.

## Further reading

- [Platform Operating Model](platform-operating-model.md)
- [Architecture Decision Records](architecture-decision-records.md)
- [Module usage and dependencies](../20-repository/module-usage-and-dependencies.md)
- [Foundation composition guide](../20-repository/foundation-composition-guide.md)
- [Environment and Delivery Lifecycle](../30-deployment/environment-lifecycle.md)
- [Operations Handbook](../50-operations/operations-handbook.md)
- [Azure DevOps pipeline](../40-pipelines/azure-devops-pipeline.md)
- [GitHub Actions pipeline](../40-pipelines/github-actions-pipeline.md)
