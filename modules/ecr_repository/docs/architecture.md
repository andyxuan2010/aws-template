# ECR repository Architecture

```mermaid
flowchart LR
  Caller["Calling root module"] --> Module["ecr_repository module"]
  Module --> R1["aws_ecr_repository"]
  Module --> R2["aws_ecr_lifecycle_policy"]
  Module --> R3["aws_ecr_repository_policy"]
```

The ecr_repository module declares 3 managed resource type(s), including `aws_ecr_repository`, `aws_ecr_lifecycle_policy`, `aws_ecr_repository_policy`.

Resources that use `count` or `for_each` are gated by inputs such as `repository_policy_json`. Review those inputs to see which optional components a deployment creates.

The module accepts 14 input(s), with 1 required.
It returns 4 output(s), including `repository_arn`, `repository_name`, `repository_url`, `registry_id`. Pass these to downstream modules instead of recreating the resources in the caller.

The caller owns the surrounding infrastructure, such as the resource group, networks, identities, and key or log destinations that this module references. See the [module README](../README.md) for inputs and usage.
