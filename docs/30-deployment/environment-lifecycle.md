# Environment and Delivery Lifecycle

This guide distinguishes repository branch names and CI gates from AWS deployment environments. The template repository validates and publishes source; consumers own actual AWS planning, applying, and resource lifecycle.

## Repository branch map

| Branch/ref | GitHub Actions behavior | Azure DevOps behavior | AWS deployment meaning |
| --- | --- | --- | --- |
| Pull request to `main`, `dev`, or `sbx` | Runs eligible validation and changed-module tests. | No PR trigger (`pr: none`). | None; there is no AWS plan or apply. |
| Push to `main`, `dev`, or `sbx` | Runs validation; optional publication jobs may run if configured. | Runs offline validation, placeholder foundation plan, and changed-module tests. | Branch name does not select or authorize an AWS account. |
| Manual GitHub dispatch | Runs the workflow; module selection safely falls back to all modules when no diff base exists. | Not applicable. | None. |

The Terraform jobs are gated by the `IS_ORIGIN` repository variable being exactly `true`. Publishing is separately gated by each destination's settings and credentials. See the [GitHub Actions Pipeline](../40-pipelines/github-actions-pipeline.md) and [Azure DevOps Pipeline](../40-pipelines/azure-devops-pipeline.md).

## Template validation lifecycle

1. GitHub Actions checks Terraform formatting, TFLint, Trivy IaC/secret findings, and the backend-free foundation example.
2. The workflow detects changed modules and validates/tests them in a parallel matrix. Shared Terraform, example, and script changes select all modules; documentation-only changes select none.
3. Azure DevOps performs corresponding formatting and foundation checks on pushes and tests changed modules in a matrix capped at four concurrent jobs.
4. Successful eligible GitHub branch runs may create a release tag or publish/mirror repository content to configured GitHub and Azure DevOps destinations.

Neither pipeline has AWS credentials or remote state. Their placeholder plan is not a plan against an AWS account, and there is no Apply job.

## Consumer deployment lifecycle

A downstream consuming root must independently define its environment-to-account mapping, provider configuration, backend, credentials or federated identity, variable sources, branch protections, approval rules, and plan/apply pipeline. Before applying, confirm these elements agree and review the complete plan. This repository does not prescribe account IDs, backend names, approval groups, or production promotion rules.

## Safe change checklist

- Confirm the consuming root, AWS account, Region, backend key, and intended environment.
- Verify identity permissions, state protections, and required approvals in the consumer deployment system.
- Review replacements, deletions, public exposure, encryption, retention, backups, route changes, and recurring costs.
- Apply only the plan reviewed under the consumer's approved process; create a fresh plan after code, state, or infrastructure changes.
- Verify resulting resources and update workload operational records.

For state or partial-apply recovery, see [Terraform State and Recovery](../50-operations/terraform-state-and-recovery.md). Repository publishing details remain in the [GitHub Actions Pipeline](../40-pipelines/github-actions-pipeline.md).
