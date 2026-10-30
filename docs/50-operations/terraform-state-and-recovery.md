# Terraform State and Recovery

Terraform state maps configuration to managed AWS objects and can contain sensitive values. The module catalog and foundation example in this repository do not own a remote deployment state. State belongs to the consuming root configuration.

## Backend readiness

The consumer selects and configures its backend, state key, encryption, access controls, locking, versioning, recovery, and retention. This repository does not configure or verify an AWS state bucket, DynamoDB lock table, or other backend protections. Confirm those safeguards with the responsible platform owner before initializing a consumer deployment.

Protect state, state backups, plan files, credentials, and Terraform logs. Keep them out of source control and unapproved artifacts or collaboration systems.

## Routine operations

Run Terraform from the consuming root with the approved environment-specific backend and variable sources. Verify the selected account, Region, workspace, and state key before planning. Do not initialize a child module directory against shared deployment state.

Use the organization's approved method to preserve protected state backups before a risky migration or recovery. The backend procedure must be documented by the consuming platform; this template cannot restore consumer state.

## Recovery workflow

1. Stop concurrent changes and identify the consuming repository, commit, account, Region, backend, key, workspace, and last operation.
2. Confirm whether a Terraform process still owns the state lock. Preserve a protected backup using the backend owner's approved process.
3. Compare the configuration, AWS resources, and state. Prefer reviewed `moved` blocks or import workflows for ownership changes.
4. After a partial apply, inspect actual AWS resources and state, then create a fresh plan. Never apply an old plan after code, state, or cloud resources changed.
5. Use state commands or force-unlock only as a controlled repair after verifying the target and confirming a lock is stale. Obtain owner approval and record the action.
6. Review the repaired plan, verify resulting AWS resources, and capture the recovery in the normal change or incident record.

Do not hand-edit state JSON or send state files through tickets, chat, or unapproved storage.

## Deletion and teardown

Remove a resource through its owning consuming configuration and reviewed plan. A full destroy plan is appropriate only for an isolated state whose entire teardown is explicitly approved. Review data retention, recovery, deletion protection, dependencies, and shared-state impact first. See [Remove a Terraform-Managed Resource](destroy-a-resource.md).
