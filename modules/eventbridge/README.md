# Amazon EventBridge

Creates an optional custom event bus, rules, targets, and archive.

## Features

- Event-pattern or scheduled rules with stable target maps.
- Dead-letter and retry controls.
- Optional custom-bus archive.

## Resources Created

An optional bus plus rules, targets, and optional archive.

## Prerequisites and Dependencies

Targets, IAM roles, and dead-letter queues must exist and grant EventBridge access.

## Basic Usage

```hcl
module "events" { source="./modules/eventbridge" name="platform-events" rules={hourly={schedule_expression="rate(1 hour)"}} }
```

## Important Behavior and Secure Defaults

Rules default enabled; retry and DLQ settings are explicit per target.

## Naming and Tagging

Stable map keys form resource names and Terraform identity.

## Testing

Run backend-free init, validate, and test.

## Known Limitations

API destinations and connections are intentionally excluded because they require secret lifecycle decisions.

## Terraform Reference

Generated from module source; do not edit manually.

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
| [aws_cloudwatch_event_archive.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_archive) | resource |
| [aws_cloudwatch_event_bus.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_bus) | resource |
| [aws_cloudwatch_event_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_archive"></a> [archive](#input\_archive) | Optional custom-bus archive. | `object({ retention_days = optional(number, 0), event_pattern = optional(string) })` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit instance. | `string` | `"001"` | no |
| <a name="input_name"></a> [name](#input\_name) | Optional custom event bus name; empty uses the default bus. | `string` | `""` | no |
| <a name="input_rules"></a> [rules](#input\_rules) | Rules and targets keyed by stable logical names. | <pre>map(object({<br>    description         = optional(string),<br>    event_pattern       = optional(string),<br>    schedule_expression = optional(string),<br>    state               = optional(string, "ENABLED"),<br>    role_arn            = optional(string),<br>    targets             = optional(map(object({ arn = string, role_arn = optional(string), input = optional(string), input_path = optional(string), dead_letter_arn = optional(string), retry_policy = optional(object({ maximum_event_age_in_seconds = optional(number, 86400), maximum_retry_attempts = optional(number, 185) })) })), {})<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | EventBridge-specific tags. | `map(string)` | `{}` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_archive_arn"></a> [archive\_arn](#output\_archive\_arn) | Archive ARN when created. |
| <a name="output_event_bus_arn"></a> [event\_bus\_arn](#output\_event\_bus\_arn) | Custom event bus ARN, or null. |
| <a name="output_event_bus_name"></a> [event\_bus\_name](#output\_event\_bus\_name) | Event bus name. |
| <a name="output_rule_arns"></a> [rule\_arns](#output\_rule\_arns) | Rule ARNs keyed by input key. |
| <a name="output_tags"></a> [tags](#output\_tags) | Effective tags. |
<!-- END_TF_DOCS -->
