# Amazon CloudWatch Monitoring Architecture

```mermaid
flowchart LR
  Caller["Calling root module"] --> Module["cloudwatch_monitoring module"]
  Module --> R1["aws_cloudwatch_log_group"]
  Module --> R2["aws_cloudwatch_metric_alarm"]
  Module --> R3["aws_cloudwatch_dashboard"]
```

The cloudwatch_monitoring module declares 3 managed resource type(s), including `aws_cloudwatch_log_group`, `aws_cloudwatch_metric_alarm`, `aws_cloudwatch_dashboard`.

Resources that use `count` or `for_each` are gated by inputs such as `log_groups`, `metric_alarms`, `dashboard_body`. Review those inputs to see which optional components a deployment creates.

The module accepts 9 input(s), with 1 required.
It returns 4 output(s), including `log_group_arns`, `alarm_arns`, `dashboard_arn`, `tags`. Pass these to downstream modules instead of recreating the resources in the caller.

The caller owns the surrounding infrastructure, such as the resource group, networks, identities, and key or log destinations that this module references. See the [module README](../README.md) for inputs and usage.
