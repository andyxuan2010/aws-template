# Amazon Route 53 Architecture

```mermaid
flowchart LR
  Caller["Calling root module"] --> Module["route53 module"]
  Module --> R1["aws_route53_zone"]
  Module --> R2["aws_route53_record"]
```

The route53 module declares 2 managed resource type(s), including `aws_route53_zone`, `aws_route53_record`.

Resources that use `count` or `for_each` are gated by inputs such as `private_zone`, `vpc_associations`, `records`. Review those inputs to see which optional components a deployment creates.

The module accepts 8 input(s), with 1 required.
It returns 5 output(s), including `zone_id`, `zone_arn`, `name_servers`, `record_fqdns`, `tags`. Pass these to downstream modules instead of recreating the resources in the caller.

The caller owns the surrounding infrastructure, such as the resource group, networks, identities, and key or log destinations that this module references. See the [module README](../README.md) for inputs and usage.
