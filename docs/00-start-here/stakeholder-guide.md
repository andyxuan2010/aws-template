# Stakeholder Reading Guide

Use this page to find repository guidance by role. The source tree documents intended controls and reusable capabilities; it does not prove live AWS health, approved budgets, or deployed resources.

| Reader | Start with | Then review |
| --- | --- | --- |
| Executives | [Executive Summary](../../README.md#executive-summary) | [Platform Operating Model](../10-architecture/platform-operating-model.md), [Cost and Budget Guide](../50-operations/cost-and-budget-guide.md), and [Validation Summary](../70-validation/validation-summary.md). |
| Platform owners | [Repository Architecture](../10-architecture/repository-architecture.md) | [Platform Operating Model](../10-architecture/platform-operating-model.md), [Environment and Delivery Lifecycle](../30-deployment/environment-lifecycle.md), and [DevSecOps and GitOps Controls](../60-security-governance/devsecops-gitops.md). |
| Solution architects | [Repository Architecture](../10-architecture/repository-architecture.md) | [Module Usage and Dependencies](../20-repository/module-usage-and-dependencies.md), [AWS Identity and Access](../60-security-governance/aws-identity-and-access.md), and [Architecture Decision Records](../10-architecture/architecture-decision-records.md). |
| Terraform engineers | [Repository Map](repo-map.md) | [First Change Walkthrough](first-change.md), [Modules Index](../20-repository/modules-index.md), [Module Documentation Standard](../20-repository/module-documentation-standard.md), and the selected module README. |
| DevOps engineers | [Environment and Delivery Lifecycle](../30-deployment/environment-lifecycle.md) | [GitHub Actions Pipeline](../40-pipelines/github-actions-pipeline.md), [Azure DevOps Pipeline](../40-pipelines/azure-devops-pipeline.md), and [Operations Handbook](../50-operations/operations-handbook.md). |
| Security and governance | [DevSecOps and GitOps Controls](../60-security-governance/devsecops-gitops.md) | [AWS Identity and Access](../60-security-governance/aws-identity-and-access.md), [Naming Convention](../60-security-governance/naming-convention.md), and [Tagging Standard](../60-security-governance/tagging-standard.md). |
| Finance and service owners | [Cost and Budget Guide](../50-operations/cost-and-budget-guide.md) | [Tagging Standard](../60-security-governance/tagging-standard.md), module READMEs, and the approved plan for the consuming workload. |

## Questions this repository can answer

- **What can the catalog build?** See the [README portfolio](../../README.md#portfolio-at-a-glance) and [Modules Index](../20-repository/modules-index.md).
- **How are modules composed?** Read [Module Usage and Dependencies](../20-repository/module-usage-and-dependencies.md) and the [Foundation Composition Guide](../20-repository/foundation-composition-guide.md).
- **What runs when code changes?** Read the [Environment and Delivery Lifecycle](../30-deployment/environment-lifecycle.md) and pipeline guides.
- **Where does AWS identity and permission design belong?** See [AWS Identity and Access](../60-security-governance/aws-identity-and-access.md); live roles and policies are owned by the consuming platform.
- **What should happen when state or a pipeline fails?** Start with the [Operations Handbook](../50-operations/operations-handbook.md).

## Questions requiring owner or live evidence

This repository alone cannot establish current AWS health, actual resources, account controls, service quotas, approved budgets, measured costs, service criticality, recovery objectives, support SLAs, or whether GitHub/Azure DevOps settings match the documented intent. Confirm these with the responsible platform, security, service, and finance owners.
