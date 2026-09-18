# Amazon CloudWatch Monitoring

Creates CloudWatch log groups, metric alarms, and an optional dashboard.

## Features

- Stable maps of encrypted-capable log groups and metric alarms.
- One-year log retention by default and explicit missing-data behavior.
- Optional JSON dashboard.

## Resources Created

CloudWatch log groups, metric alarms, and optionally a dashboard.

## Prerequisites and Dependencies

Customer-managed encryption requires an existing KMS key; notification actions require existing SNS topics.

## Basic Usage

```hcl
module "monitoring" { source="./modules/cloudwatch_monitoring" region_code="use1" log_groups={app={}} }
```

## Important Behavior and Secure Defaults

Logs retain for 365 days. Set `skip_destroy` only where retained log groups are operationally managed.

## Naming and Tagging

Generated names follow the repository convention and merge inherited and resource tags.

## Testing

Run backend-free init, validate, and test.

## Known Limitations

Composite alarms, metric filters, and subscription filters are separate capabilities.

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
| [aws_cloudwatch_dashboard.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_dashboard) | resource |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_metric_alarm.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dashboard_body"></a> [dashboard\_body](#input\_dashboard\_body) | Optional CloudWatch dashboard JSON. | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit instance. | `string` | `"001"` | no |
| <a name="input_log_groups"></a> [log\_groups](#input\_log\_groups) | Log groups keyed by stable logical name. | <pre>map(object({<br>    name              = optional(string),<br>    retention_in_days = optional(number, 365),<br>    kms_key_id        = optional(string),<br>    skip_destroy      = optional(bool, false),<br>    tags              = optional(map(string), {})<br>  }))</pre> | `{}` | no |
| <a name="input_metric_alarms"></a> [metric\_alarms](#input\_metric\_alarms) | Metric alarms keyed by stable logical name. | <pre>map(object({<br>    alarm_name          = optional(string),<br>    comparison_operator = string,<br>    evaluation_periods  = number,<br>    threshold           = number,<br>    metric_name         = string,<br>    namespace           = string,<br>    period              = optional(number, 300),<br>    statistic           = optional(string, "Average"),<br>    dimensions          = optional(map(string), {}),<br>    alarm_actions       = optional(list(string), []),<br>    ok_actions          = optional(list(string), []),<br>    treat_missing_data  = optional(string, "missing")<br>    description         = optional(string),<br>    tags                = optional(map(string), {})<br>  }))</pre> | `{}` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short AWS region code. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Monitoring tags. | `map(string)` | `{}` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alarm_arns"></a> [alarm\_arns](#output\_alarm\_arns) | Alarm ARNs keyed by input key. |
| <a name="output_dashboard_arn"></a> [dashboard\_arn](#output\_dashboard\_arn) | Dashboard ARN when created. |
| <a name="output_log_group_arns"></a> [log\_group\_arns](#output\_log\_group\_arns) | Log group ARNs keyed by input key. |
| <a name="output_tags"></a> [tags](#output\_tags) | Effective base tags. |
<!-- END_TF_DOCS -->
