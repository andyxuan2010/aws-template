# Amazon EventBridge Architecture

```mermaid
flowchart LR
  Caller["Calling root module"] --> Module["eventbridge module"]
  Module --> R1["aws_cloudwatch_event_bus"]
  Module --> R2["aws_cloudwatch_event_rule"]
  Module --> R3["aws_cloudwatch_event_target"]
  Module --> R4["aws_cloudwatch_event_archive"]
```

The eventbridge module declares 4 managed resource type(s), including `aws_cloudwatch_event_bus`, `aws_cloudwatch_event_rule`, `aws_cloudwatch_event_target`, `aws_cloudwatch_event_archive`.

Resources that use `count` or `for_each` are gated by inputs such as `rules`, `archive`. Review those inputs to see which optional components a deployment creates.

The module accepts 8 input(s), with 0 required.
It returns 5 output(s), including `event_bus_name`, `event_bus_arn`, `rule_arns`, `archive_arn`, `tags`. Pass these to downstream modules instead of recreating the resources in the caller.

The caller owns the surrounding infrastructure, such as the resource group, networks, identities, and key or log destinations that this module references. See the [module README](../README.md) for inputs and usage.
