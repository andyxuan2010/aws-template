# SNS topic Architecture

```mermaid
flowchart LR
  Caller["Calling root module"] --> Module["sns_topic module"]
  Module --> R1["aws_sns_topic"]
  Module --> R2["aws_sns_topic_data_protection_policy"]
  Module --> R3["aws_sns_topic_subscription"]
```

The sns_topic module declares 3 managed resource type(s), including `aws_sns_topic`, `aws_sns_topic_data_protection_policy`, `aws_sns_topic_subscription`.

Resources that use `count` or `for_each` are gated by inputs such as `data_protection_policy_json`, `subscriptions`. Review those inputs to see which optional components a deployment creates.

The module accepts 19 input(s), with 2 required.
It returns 4 output(s), including `topic_arn`, `topic_name`, `subscription_arns`, `subscription_ids`. Pass these to downstream modules instead of recreating the resources in the caller.

The caller owns the surrounding infrastructure, such as the resource group, networks, identities, and key or log destinations that this module references. See the [module README](../README.md) for inputs and usage.
