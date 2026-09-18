# SQS queue module

Creates an encrypted standard or FIFO queue. SQS-managed encryption and
20-second long polling are enabled by default. A customer-managed KMS key and
resource policy can be supplied explicitly.

```hcl
module "orders" {
  source = "../../modules/sqs_queue"

  region_code = "use1"
  dead_letter_queue = {
    arn               = module.orders_dlq.queue_arn
    max_receive_count = 5
  }
}
```

Production queues require a dead-letter queue. Create the DLQ as a separate
module instance so its retention, consumers, and access policy remain explicit.
The module normalizes the `.fifo` suffix.
## Prerequisites and Dependencies

Configure the AWS provider and credentials in the calling root module. Pass
dependencies through typed inputs and module outputs; this child module does
not configure providers or a backend.

## Important Behavior and Secure Defaults

Review the module defaults, lifecycle implications, replacement behavior, and
AWS service costs before use. Production guardrails fail during planning when
an unsafe combination can be detected statically.

## Naming and Tagging

Generated names and effective tags follow the repository
[naming convention](../../docs/NAMING_CONVENTION.md) and
[tagging standard](../../docs/TAGGING_STANDARD.md). Stable map keys are
Terraform resource identity and should not be renamed casually.

## Testing

`powershell
terraform init -backend=false
terraform validate
terraform test
`

Tests use mocked providers and do not apply AWS resources.

## Known Limitations

The module owns only the resources documented below. Account-level policies,
cross-account trust, service quotas, and live integration verification remain
the responsibility of the calling composition.

## Terraform Reference

The content below is generated from module source. Do not edit it manually.

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
| [aws_sqs_queue.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_content_based_deduplication"></a> [content\_based\_deduplication](#input\_content\_based\_deduplication) | Enable content-based deduplication for FIFO queues. | `bool` | `false` | no |
| <a name="input_dead_letter_queue"></a> [dead\_letter\_queue](#input\_dead\_letter\_queue) | Optional dead-letter queue configuration. | <pre>object({<br>    arn               = string<br>    max_receive_count = optional(number, 5)<br>  })</pre> | `null` | no |
| <a name="input_deduplication_scope"></a> [deduplication\_scope](#input\_deduplication\_scope) | FIFO deduplication scope. | `string` | `null` | no |
| <a name="input_delay_seconds"></a> [delay\_seconds](#input\_delay\_seconds) | Default delivery delay. | `number` | `0` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_fifo_queue"></a> [fifo\_queue](#input\_fifo\_queue) | Create a FIFO queue. | `bool` | `false` | no |
| <a name="input_fifo_throughput_limit"></a> [fifo\_throughput\_limit](#input\_fifo\_throughput\_limit) | FIFO throughput quota mode. | `string` | `null` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_kms_data_key_reuse_period_seconds"></a> [kms\_data\_key\_reuse\_period\_seconds](#input\_kms\_data\_key\_reuse\_period\_seconds) | KMS data-key reuse period. | `number` | `300` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | Optional customer-managed KMS key ID or ARN. SQS-managed encryption is used when null. | `string` | `null` | no |
| <a name="input_max_message_size"></a> [max\_message\_size](#input\_max\_message\_size) | Maximum message size in bytes. | `number` | `262144` | no |
| <a name="input_message_retention_seconds"></a> [message\_retention\_seconds](#input\_message\_retention\_seconds) | Message retention period. | `number` | `345600` | no |
| <a name="input_name"></a> [name](#input\_name) | Explicit queue name. The module appends .fifo when required. | `string` | `""` | no |
| <a name="input_queue_policy_json"></a> [queue\_policy\_json](#input\_queue\_policy\_json) | Optional queue resource policy JSON. | `string` | `null` | no |
| <a name="input_receive_wait_time_seconds"></a> [receive\_wait\_time\_seconds](#input\_receive\_wait\_time\_seconds) | Long-poll wait time. | `number` | `20` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short AWS region code. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Queue-specific tags. | `map(string)` | `{}` | no |
| <a name="input_visibility_timeout_seconds"></a> [visibility\_timeout\_seconds](#input\_visibility\_timeout\_seconds) | Message visibility timeout. | `number` | `30` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_queue_arn"></a> [queue\_arn](#output\_queue\_arn) | Queue ARN. |
| <a name="output_queue_id"></a> [queue\_id](#output\_queue\_id) | Queue URL. |
| <a name="output_queue_name"></a> [queue\_name](#output\_queue\_name) | Resolved queue name. |
| <a name="output_queue_url"></a> [queue\_url](#output\_queue\_url) | Queue URL. |
<!-- END_TF_DOCS -->
