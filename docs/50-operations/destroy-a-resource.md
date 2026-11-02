# Remove a Terraform-Managed Resource

Remove resources through the consuming Terraform root and state that own them. This repository's module validation workflow does not deploy or destroy AWS resources.

## Before changing configuration

1. Identify the exact resource, module instance, consumer environment, account, Region, backend key, workspace, and owning configuration. Search for dependent resources and consumers.
2. Check service health, data retention, backup and restore requirements, dependencies, deletion protection, service recovery behavior, and module lifecycle settings such as `force_destroy`.
3. Obtain the normal workload, platform, data, and change approvals. Confirm that no concurrent Terraform run is modifying the same state.
4. Preserve state only through the consumer backend owner's approved protected backup process.

## Plan the removal

1. On a feature branch, remove or disable the resource through the owning consuming configuration, or use a reviewed move/import change if ownership is being transferred. Avoid broad targeting as a substitute for correcting configuration.
2. Use the correct account, Region, backend, workspace, and approved variable sources to create a fresh plan.
3. Review the complete plan. Confirm the intended resource is the only destructive change; investigate every unexpected replacement or destroy and check shared dependencies and data-bearing services.
4. Submit the change for peer review and required approvals. Apply only the exact plan approved by the consumer deployment process.
5. Verify the resource and dependent services after apply. Record retained, recoverable, or permanently deleted data and update relevant operational documentation.

A full destroy plan is appropriate only for an isolated state whose complete teardown is explicitly approved. It is not a safe way to remove one resource from a shared consumer state. See [Terraform State and Recovery](terraform-state-and-recovery.md), [Module State and Lifecycle Ownership](module-state-and-lifecycle.md), and the [Foundation Composition Guide](../20-repository/foundation-composition-guide.md).
