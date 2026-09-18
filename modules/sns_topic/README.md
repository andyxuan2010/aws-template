# SNS topic module

Creates an encrypted standard or FIFO SNS topic and optional subscriptions.
A customer-managed KMS key is required, signatures use version 2, and standard
topics enable active X-Ray tracing.

```hcl
module "events" {
  source = "../../modules/sns_topic"

  region_code      = "use1"
  kms_master_key_id = module.kms.key_arn
  subscriptions = {
    processing_queue = {
      protocol = "sqs"
      endpoint = module.processing_queue.queue_arn
    }
  }
}
```

Plaintext HTTP subscriptions are rejected unless explicitly allowed. Subscription
keys are Terraform identity and should remain stable. Queue, Lambda, and
Firehose destinations generally require a corresponding resource policy.
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
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_data_protection_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_data_protection_policy) | resource |
| [aws_sns_topic_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_insecure_http_subscriptions"></a> [allow\_insecure\_http\_subscriptions](#input\_allow\_insecure\_http\_subscriptions) | Allow plaintext HTTP subscription endpoints. | `bool` | `false` | no |
| <a name="input_archive_policy_json"></a> [archive\_policy\_json](#input\_archive\_policy\_json) | Optional FIFO message archive policy JSON. | `string` | `null` | no |
| <a name="input_content_based_deduplication"></a> [content\_based\_deduplication](#input\_content\_based\_deduplication) | Enable content-based deduplication for FIFO topics. | `bool` | `false` | no |
| <a name="input_data_protection_policy_json"></a> [data\_protection\_policy\_json](#input\_data\_protection\_policy\_json) | Optional SNS data-protection policy JSON. | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Optional topic display name. | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_fifo_throughput_scope"></a> [fifo\_throughput\_scope](#input\_fifo\_throughput\_scope) | FIFO throughput scope. | `string` | `null` | no |
| <a name="input_fifo_topic"></a> [fifo\_topic](#input\_fifo\_topic) | Create a FIFO topic. | `bool` | `false` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | Customer-managed KMS key ID or ARN. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Explicit topic name. The module appends .fifo when required. | `string` | `""` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short AWS region code. | `string` | n/a | yes |
| <a name="input_signature_version"></a> [signature\_version](#input\_signature\_version) | SNS signature version. | `number` | `2` | no |
| <a name="input_subscriptions"></a> [subscriptions](#input\_subscriptions) | Topic subscriptions keyed by stable logical name. | <pre>map(object({<br>    protocol                        = string<br>    endpoint                        = string<br>    endpoint_auto_confirms          = optional(bool, false)<br>    confirmation_timeout_in_minutes = optional(number, 1)<br>    raw_message_delivery            = optional(bool, false)<br>    filter_policy                   = optional(string)<br>    filter_policy_scope             = optional(string, "MessageAttributes")<br>    redrive_policy                  = optional(string)<br>    subscription_role_arn           = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Topic-specific tags. | `map(string)` | `{}` | no |
| <a name="input_topic_policy_json"></a> [topic\_policy\_json](#input\_topic\_policy\_json) | Optional resource policy JSON. | `string` | `null` | no |
| <a name="input_tracing_config"></a> [tracing\_config](#input\_tracing\_config) | X-Ray tracing mode for standard topics. | `string` | `"Active"` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subscription_arns"></a> [subscription\_arns](#output\_subscription\_arns) | Subscription ARNs keyed by logical name. |
| <a name="output_subscription_ids"></a> [subscription\_ids](#output\_subscription\_ids) | Subscription IDs keyed by logical name. |
| <a name="output_topic_arn"></a> [topic\_arn](#output\_topic\_arn) | SNS topic ARN. |
| <a name="output_topic_name"></a> [topic\_name](#output\_topic\_name) | Resolved topic name. |
<!-- END_TF_DOCS -->
