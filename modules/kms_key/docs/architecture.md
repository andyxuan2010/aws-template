# KMS key Architecture

```mermaid
flowchart LR
  Caller["Calling root module"] --> Module["kms_key module"]
  Module --> R1["aws_kms_key"]
  Module --> R2["aws_kms_alias"]
  Module --> R3["aws_kms_grant"]
```

The kms_key module declares 3 managed resource type(s), including `aws_kms_key`, `aws_kms_alias`, `aws_kms_grant`.

Resources that use `count` or `for_each` are gated by inputs such as `enable_alias`, `grants`. Review those inputs to see which optional components a deployment creates.

The module accepts 17 input(s), with 1 required.
It returns 5 output(s), including `key_id`, `key_arn`, `alias_arn`, `alias_name`, `name`. Pass these to downstream modules instead of recreating the resources in the caller.

The caller owns the surrounding infrastructure, such as the resource group, networks, identities, and key or log destinations that this module references. See the [module README](../README.md) for inputs and usage.
