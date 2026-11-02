# IAM role Architecture

```mermaid
flowchart LR
  Caller["Calling root module"] --> Module["iam_role module"]
  Module --> R1["aws_iam_role"]
  Module --> R2["aws_iam_role_policy_attachment"]
  Module --> R3["aws_iam_role_policy"]
  Module --> R4["aws_iam_instance_profile"]
```

The iam_role module declares 4 managed resource type(s), including `aws_iam_role`, `aws_iam_role_policy_attachment`, `aws_iam_role_policy`, `aws_iam_instance_profile`.

Resources that use `count` or `for_each` are gated by inputs such as `assume_role_policy_json`, `trust_policy_statements`, `managed_policy_arns`, `inline_policies`, `create_instance_profile`. Review those inputs to see which optional components a deployment creates.

The module accepts 16 input(s), with 0 required.
It returns 5 output(s), including `role_id`, `role_arn`, `role_name`, `instance_profile_arn`, `instance_profile_name`. Pass these to downstream modules instead of recreating the resources in the caller.

The caller owns the surrounding infrastructure, such as the resource group, networks, identities, and key or log destinations that this module references. See the [module README](../README.md) for inputs and usage.
