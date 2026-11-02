# AWS Certificate Manager Certificate Architecture

```mermaid
flowchart LR
  Caller["Calling root module"] --> Module["acm_certificate module"]
  Module --> R1["aws_acm_certificate"]
  Module --> R2["aws_route53_record"]
  Module --> R3["aws_acm_certificate_validation"]
```

The acm_certificate module declares 3 managed resource type(s), including `aws_acm_certificate`, `aws_route53_record`, `aws_acm_certificate_validation`.

Resources that use `count` or `for_each` are gated by inputs such as `wait_for_validation`, `validation_method`. Review those inputs to see which optional components a deployment creates.

The module accepts 10 input(s), with 1 required.
It returns 5 output(s), including `certificate_arn`, `domain_name`, `domain_validation_options`, `validation_record_fqdns`, `tags`. Pass these to downstream modules instead of recreating the resources in the caller.

The caller owns the surrounding infrastructure, such as the resource group, networks, identities, and key or log destinations that this module references. See the [module README](../README.md) for inputs and usage.
