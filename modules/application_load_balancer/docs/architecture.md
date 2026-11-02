# Application Load Balancer Architecture

```mermaid
flowchart LR
  Caller["Calling root module"] --> Module["application_load_balancer module"]
  Module --> R1["aws_lb"]
  Module --> R2["aws_lb_target_group"]
  Module --> R3["aws_lb_listener"]
```

The application_load_balancer module declares 3 managed resource type(s), including `aws_lb`, `aws_lb_target_group`, `aws_lb_listener`.

Resources that use `count` or `for_each` are gated by inputs such as `access_logs`, `target_groups`, `listeners`. Review those inputs to see which optional components a deployment creates.

The module accepts 18 input(s), with 6 required.
It returns 7 output(s), including `load_balancer_arn`, `load_balancer_arn_suffix`, `dns_name`, `zone_id`, `target_group_arns`, `listener_arns`. Pass these to downstream modules instead of recreating the resources in the caller.

The caller owns the surrounding infrastructure, such as the resource group, networks, identities, and key or log destinations that this module references. See the [module README](../README.md) for inputs and usage.
