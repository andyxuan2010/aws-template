# Operations Handbook

Use this page to route a failed validation or consumer Terraform operation. Do not rerun an apply or change state until the target environment and current operation status are known.

## First-response checklist

1. Record the repository, branch, commit, workflow/build run, consumer environment, account and Region, backend key, workspace, and failure time.
2. Identify the failed job and first actionable error. Check whether an upstream gate intentionally skipped dependent jobs.
3. Determine whether the run reached a plan or apply. A consumer deployment can have partially changed AWS resources if failure occurred during apply.
4. Check for another active run or state lock before retrying.
5. Escalate using the owning service team's incident process. This repository does not define an on-call rota or severity SLA.

## Common symptoms

| Symptom | First checks | Guide |
| --- | --- | --- |
| Only the workflow gate runs or Terraform jobs skip | Check `IS_ORIGIN`; Terraform jobs require exactly `true`. | [GitHub Actions Pipeline](../40-pipelines/github-actions-pipeline.md) |
| Trivy or Terraform static validation fails | Review the first finding, changed files, and scanner output; do not suppress a finding without review. | [Validation Summary](../70-validation/validation-summary.md) |
| Module validation matrix has no jobs | Confirm the change is not documentation-only and inspect target detection output. Shared Terraform/example/script changes select all modules. | GitHub or [Azure DevOps Pipeline](../40-pipelines/azure-devops-pipeline.md) |
| Optional repository publish job is skipped | Check the destination variable, matching token/PAT, toggle, event, branch, and destination permissions. | [GitHub Actions Pipeline](../40-pipelines/github-actions-pipeline.md) |
| Azure DevOps build does not run for a PR | The checked-in ADO pipeline has `pr: none`; pull request validation is in GitHub Actions. | [Azure DevOps Pipeline](../40-pipelines/azure-devops-pipeline.md) |
| Consumer Terraform reports a state lock | Confirm whether an active process owns it. Use recovery steps only for a confirmed stale lock. | [Terraform State and Recovery](terraform-state-and-recovery.md) |
| Consumer apply failed or resources are partially changed | Stop concurrent runs, inspect AWS resources and state, preserve a protected backup, and make a fresh plan. | [Terraform State and Recovery](terraform-state-and-recovery.md) |
| A resource deletion is requested | Confirm the owning state, data retention, protection settings, dependencies, and full destructive plan. | [Remove a Terraform-Managed Resource](destroy-a-resource.md) |

## Recovery boundaries

- Do not reuse a saved plan after source, state, or AWS resources have changed.
- Do not hand-edit state JSON or upload it to tickets or chat.
- Do not force-unlock state while a Terraform process may still own the lock.
- Do not run a full destroy plan to remove one resource from shared state.
- Use the [Terraform State and Recovery](terraform-state-and-recovery.md) and [Remove a Terraform-Managed Resource](destroy-a-resource.md) procedures for consumer state or deletion work.

## After recovery

Confirm the final plan and affected AWS resources, capture the change or incident record, and update the module or runbook if the event exposed a documentation gap. Obtain support hours, severity definitions, and escalation contacts from the service owner; they are not defined by this repository.
