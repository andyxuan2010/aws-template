# Security Hub CSPM Architecture

```mermaid
flowchart LR
  Caller["Calling root module"] --> Module["security_hub_cspm module"]
  Module --> R1["aws_securityhub_account"]
  Module --> R2["aws_securityhub_standards_subscription"]
  Module --> R3["aws_securityhub_finding_aggregator"]
```

The security_hub_cspm module declares 3 managed resource type(s), including `aws_securityhub_account`, `aws_securityhub_standards_subscription`, `aws_securityhub_finding_aggregator`.

Resources that use `count` or `for_each` are gated by inputs such as `standards_arns`. Review those inputs to see which optional components a deployment creates.

The module accepts 4 input(s), with 0 required.
It returns 4 output(s), including `account_id`, `hub_arn`, `standards_subscription_arns`, `finding_aggregator_arn`. Pass these to downstream modules instead of recreating the resources in the caller.

The caller owns the surrounding infrastructure, such as the resource group, networks, identities, and key or log destinations that this module references. See the [module README](../README.md) for inputs and usage.
