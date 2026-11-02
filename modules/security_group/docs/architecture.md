# Security group Architecture

```mermaid
flowchart LR
  Caller["Calling root module"] --> Module["security_group module"]
  Module --> R1["aws_security_group"]
  Module --> R2["aws_vpc_security_group_ingress_rule"]
  Module --> R3["aws_vpc_security_group_egress_rule"]
```

The security_group module declares 3 managed resource type(s), including `aws_security_group`, `aws_vpc_security_group_ingress_rule`, `aws_vpc_security_group_egress_rule`.

Resources that use `count` or `for_each` are gated by inputs such as `ingress_rules`, `egress_rules`. Review those inputs to see which optional components a deployment creates.

The module accepts 13 input(s), with 2 required.
It returns 5 output(s), including `security_group_id`, `security_group_arn`, `name`, `ingress_rule_ids`, `egress_rule_ids`. Pass these to downstream modules instead of recreating the resources in the caller.

The caller owns the surrounding infrastructure, such as the resource group, networks, identities, and key or log destinations that this module references. See the [module README](../README.md) for inputs and usage.
