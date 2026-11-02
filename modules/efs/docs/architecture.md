# EFS Architecture

```mermaid
flowchart LR
  Caller["Calling root module"] --> Module["efs module"]
  Module --> R1["aws_efs_file_system"]
  Module --> R2["aws_efs_backup_policy"]
  Module --> R3["aws_efs_mount_target"]
  Module --> R4["aws_efs_access_point"]
```

The efs module declares 4 managed resource type(s), including `aws_efs_file_system`, `aws_efs_backup_policy`, `aws_efs_mount_target`, `aws_efs_access_point`.

Resources that use `count` or `for_each` are gated by inputs such as `subnet_ids`, `access_points`. Review those inputs to see which optional components a deployment creates.

The module accepts 14 input(s), with 3 required.
It returns 4 output(s), including `file_system_id`, `file_system_arn`, `mount_target_ids`, `access_point_ids`. Pass these to downstream modules instead of recreating the resources in the caller.

The caller owns the surrounding infrastructure, such as the resource group, networks, identities, and key or log destinations that this module references. See the [module README](../README.md) for inputs and usage.
