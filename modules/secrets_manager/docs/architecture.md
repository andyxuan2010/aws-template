# Secrets Manager Architecture

```mermaid
flowchart LR
  Caller["Calling root module"] --> Module["secrets_manager module"]
  Module --> R1["aws_secretsmanager_secret"]
  Module --> R2["aws_secretsmanager_secret_policy"]
  Module --> R3["aws_secretsmanager_secret_rotation"]
```

The secrets_manager module declares 3 managed resource type(s), including `aws_secretsmanager_secret`, `aws_secretsmanager_secret_policy`, `aws_secretsmanager_secret_rotation`.

Resources that use `count` or `for_each` are gated by inputs such as `replicas`, `resource_policy_json`, `rotation`. Review those inputs to see which optional components a deployment creates.

The module accepts 15 input(s), with 1 required.
It returns 4 output(s), including `secret_id`, `secret_arn`, `name`, `replica_status`. Pass these to downstream modules instead of recreating the resources in the caller.

The caller owns the surrounding infrastructure, such as the resource group, networks, identities, and key or log destinations that this module references. See the [module README](../README.md) for inputs and usage.
