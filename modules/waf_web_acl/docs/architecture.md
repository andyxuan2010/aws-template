# AWS WAF Web ACL Architecture

```mermaid
flowchart LR
  Caller["Calling root module"] --> Module["waf_web_acl module"]
  Module --> R1["aws_wafv2_web_acl"]
  Module --> R2["aws_wafv2_web_acl_association"]
```

The waf_web_acl module declares 2 managed resource type(s), including `aws_wafv2_web_acl`, `aws_wafv2_web_acl_association`.

Resources that use `count` or `for_each` are gated by inputs such as `default_action`, `managed_rule_groups`, `rate_based_rules`, `resource_arns`. Review those inputs to see which optional components a deployment creates.

The module accepts 14 input(s), with 1 required.
It returns 5 output(s), including `web_acl_id`, `web_acl_arn`, `capacity`, `association_ids`, `tags`. Pass these to downstream modules instead of recreating the resources in the caller.

The caller owns the surrounding infrastructure, such as the resource group, networks, identities, and key or log destinations that this module references. See the [module README](../README.md) for inputs and usage.
