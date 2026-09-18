# AWS WAF Web ACL

Creates a regional or CloudFront WAFv2 web ACL with managed and rate-based protection.

## Features

- AWS Common Rule Set enabled by default.
- Managed-rule exclusions, rate limiting, metrics, sampling, and regional associations.

## Resources Created

One web ACL and optional regional resource associations.

## Prerequisites and Dependencies

CloudFront-scoped ACLs require an `us-east-1` provider and association by the distribution configuration.

## Basic Usage

```hcl
module "waf" { source="./modules/waf_web_acl" region_code="use1" resource_arns=[module.alb.arn] }
```

## Important Behavior and Secure Defaults

AWS managed common protections, metrics, and sampled requests are enabled. Rule priorities must be unique.

## Naming and Tagging

Names and tags follow repository standards.

## Testing

Run backend-free init, validate, and test.

## Known Limitations

Custom nested statements and WAF logging destinations are intentionally separate modules.

## Terraform Reference

Generated from source; do not edit manually.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0, < 7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_wafv2_web_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_metrics_enabled"></a> [cloudwatch\_metrics\_enabled](#input\_cloudwatch\_metrics\_enabled) | Publish WAF metrics. | `bool` | `true` | no |
| <a name="input_default_action"></a> [default\_action](#input\_default\_action) | ALLOW or BLOCK unmatched traffic. | `string` | `"ALLOW"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit instance. | `string` | `"001"` | no |
| <a name="input_managed_rule_groups"></a> [managed\_rule\_groups](#input\_managed\_rule\_groups) | Managed rule groups keyed by stable logical name. | `map(object({ priority = number, vendor_name = optional(string, "AWS"), name = string, excluded_rules = optional(set(string), []), override_action = optional(string, "none") }))` | <pre>{<br>  "common": {<br>    "name": "AWSManagedRulesCommonRuleSet",<br>    "priority": 10<br>  }<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Optional web ACL name. | `string` | `""` | no |
| <a name="input_rate_based_rules"></a> [rate\_based\_rules](#input\_rate\_based\_rules) | Rate rules keyed by stable logical name. | `map(object({ priority = number, limit = number, aggregate_key_type = optional(string, "IP"), action = optional(string, "block") }))` | `{}` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short AWS region code. | `string` | n/a | yes |
| <a name="input_resource_arns"></a> [resource\_arns](#input\_resource\_arns) | Regional resource ARNs to associate. | `set(string)` | `[]` | no |
| <a name="input_sampled_requests_enabled"></a> [sampled\_requests\_enabled](#input\_sampled\_requests\_enabled) | Retain sampled requests. | `bool` | `true` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | REGIONAL or CLOUDFRONT scope. | `string` | `"REGIONAL"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Web ACL tags. | `map(string)` | `{}` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_association_ids"></a> [association\_ids](#output\_association\_ids) | Association IDs keyed by ARN. |
| <a name="output_capacity"></a> [capacity](#output\_capacity) | Web ACL capacity units. |
| <a name="output_tags"></a> [tags](#output\_tags) | Effective tags. |
| <a name="output_web_acl_arn"></a> [web\_acl\_arn](#output\_web\_acl\_arn) | Web ACL ARN. |
| <a name="output_web_acl_id"></a> [web\_acl\_id](#output\_web\_acl\_id) | Web ACL ID. |
<!-- END_TF_DOCS -->
