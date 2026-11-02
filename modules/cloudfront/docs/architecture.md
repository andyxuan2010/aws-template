# CloudFront Architecture

```mermaid
flowchart LR
  Caller["Calling root module"] --> Module["cloudfront module"]
  Module --> R1["aws_cloudfront_origin_access_control"]
  Module --> R2["aws_cloudfront_distribution"]
```

The cloudfront module declares 2 managed resource type(s), including `aws_cloudfront_origin_access_control`, `aws_cloudfront_distribution`.

Resources that use `count` or `for_each` are gated by inputs such as `origins`. Review those inputs to see which optional components a deployment creates.

The module accepts 11 input(s), with 4 required.
It returns 4 output(s), including `distribution_id`, `distribution_arn`, `domain_name`, `origin_access_control_ids`. Pass these to downstream modules instead of recreating the resources in the caller.

The caller owns the surrounding infrastructure, such as the resource group, networks, identities, and key or log destinations that this module references. See the [module README](../README.md) for inputs and usage.
