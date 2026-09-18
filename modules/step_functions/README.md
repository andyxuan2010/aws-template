# AWS Step Functions

Creates a Standard or Express state machine with logging and tracing controls.

## Features

- Validated Amazon States Language JSON, execution role, optional version publishing, logs, and X-Ray.

## Resources Created

One Step Functions state machine.

## Prerequisites and Dependencies

Supply a least-privilege IAM role and, when enabled, a CloudWatch Logs destination ending in `:*`.

## Basic Usage

```hcl
module "workflow" { source="./modules/step_functions" region_code="use1" role_arn=aws_iam_role.workflow.arn definition=jsonencode({StartAt="Done",States={Done={Type="Succeed"}}}) }
```

## Important Behavior and Secure Defaults

X-Ray is enabled; execution data logging is disabled to avoid leaking sensitive payloads. Express workflows require logs.

## Naming and Tagging

Names and tags follow repository standards.

## Testing

Run backend-free init, validate, and test.

## Known Limitations

IAM permissions and log resource policies are caller-owned.

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
| [aws_sfn_state_machine.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sfn_state_machine) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_definition"></a> [definition](#input\_definition) | Amazon States Language JSON. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_include_execution_data"></a> [include\_execution\_data](#input\_include\_execution\_data) | Include execution input/output in logs; may contain sensitive data. | `bool` | `false` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit instance. | `string` | `"001"` | no |
| <a name="input_log_destination"></a> [log\_destination](#input\_log\_destination) | CloudWatch Logs destination ARN ending in :*. | `string` | `null` | no |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | OFF, ERROR, ALL, or FATAL. | `string` | `"ERROR"` | no |
| <a name="input_name"></a> [name](#input\_name) | Optional state machine name. | `string` | `""` | no |
| <a name="input_publish"></a> [publish](#input\_publish) | Publish an immutable state-machine version. | `bool` | `false` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short AWS region code. | `string` | n/a | yes |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | Execution IAM role ARN. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | State-machine tags. | `map(string)` | `{}` | no |
| <a name="input_tracing_enabled"></a> [tracing\_enabled](#input\_tracing\_enabled) | Enable X-Ray tracing. | `bool` | `true` | no |
| <a name="input_type"></a> [type](#input\_type) | STANDARD or EXPRESS. | `string` | `"STANDARD"` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_creation_date"></a> [creation\_date](#output\_creation\_date) | State machine creation date. |
| <a name="output_state_machine_arn"></a> [state\_machine\_arn](#output\_state\_machine\_arn) | State machine ARN. |
| <a name="output_state_machine_id"></a> [state\_machine\_id](#output\_state\_machine\_id) | State machine ID. |
| <a name="output_tags"></a> [tags](#output\_tags) | Effective tags. |
<!-- END_TF_DOCS -->
