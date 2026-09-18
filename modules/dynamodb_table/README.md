# DynamoDB table module

Creates an encrypted DynamoDB table with on-demand billing, point-in-time
recovery, and deletion protection by default. Provisioned capacity, secondary
indexes, TTL, and streams are optional.

```hcl
module "sessions" {
  source = "../../modules/dynamodb_table"

  region_code = "use1"
  hash_key    = "session_id"
  attributes = {
    session_id = { type = "S" }
  }
  ttl_attribute_name = "expires_at"
}
```

Only key attributes belong in `attributes`; DynamoDB is schemaless for all other
fields. The module fails if key definitions and attribute declarations drift.
Production requires point-in-time recovery and deletion protection.
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
| [aws_dynamodb_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Key attributes only, keyed by attribute name. | <pre>map(object({<br>    type = string<br>  }))</pre> | n/a | yes |
| <a name="input_billing_mode"></a> [billing\_mode](#input\_billing\_mode) | DynamoDB billing mode. | `string` | `"PAY_PER_REQUEST"` | no |
| <a name="input_deletion_protection_enabled"></a> [deletion\_protection\_enabled](#input\_deletion\_protection\_enabled) | Protect the table from deletion. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_global_secondary_indexes"></a> [global\_secondary\_indexes](#input\_global\_secondary\_indexes) | Global secondary indexes keyed by stable index name. | <pre>map(object({<br>    hash_key           = string<br>    range_key          = optional(string)<br>    projection_type    = optional(string, "ALL")<br>    non_key_attributes = optional(set(string), [])<br>    read_capacity      = optional(number)<br>    write_capacity     = optional(number)<br>  }))</pre> | `{}` | no |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | Partition key attribute name. | `string` | n/a | yes |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | Optional customer-managed KMS key ARN. | `string` | `null` | no |
| <a name="input_local_secondary_indexes"></a> [local\_secondary\_indexes](#input\_local\_secondary\_indexes) | Local secondary indexes keyed by stable index name. | <pre>map(object({<br>    range_key          = string<br>    projection_type    = optional(string, "ALL")<br>    non_key_attributes = optional(set(string), [])<br>  }))</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Explicit table name. When empty, the standard name is generated. | `string` | `""` | no |
| <a name="input_point_in_time_recovery_enabled"></a> [point\_in\_time\_recovery\_enabled](#input\_point\_in\_time\_recovery\_enabled) | Enable point-in-time recovery. | `bool` | `true` | no |
| <a name="input_range_key"></a> [range\_key](#input\_range\_key) | Optional sort key attribute name. | `string` | `null` | no |
| <a name="input_read_capacity"></a> [read\_capacity](#input\_read\_capacity) | Provisioned read capacity when billing\_mode is PROVISIONED. | `number` | `null` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short AWS region code. | `string` | n/a | yes |
| <a name="input_server_side_encryption_enabled"></a> [server\_side\_encryption\_enabled](#input\_server\_side\_encryption\_enabled) | Enable server-side encryption. | `bool` | `true` | no |
| <a name="input_stream_enabled"></a> [stream\_enabled](#input\_stream\_enabled) | Enable DynamoDB Streams. | `bool` | `false` | no |
| <a name="input_stream_view_type"></a> [stream\_view\_type](#input\_stream\_view\_type) | Stream record view type. | `string` | `null` | no |
| <a name="input_table_class"></a> [table\_class](#input\_table\_class) | DynamoDB table class. | `string` | `"STANDARD"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Table-specific tags. | `map(string)` | `{}` | no |
| <a name="input_ttl_attribute_name"></a> [ttl\_attribute\_name](#input\_ttl\_attribute\_name) | Optional TTL attribute name. | `string` | `null` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"platform"` | no |
| <a name="input_write_capacity"></a> [write\_capacity](#input\_write\_capacity) | Provisioned write capacity when billing\_mode is PROVISIONED. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_stream_arn"></a> [stream\_arn](#output\_stream\_arn) | Latest DynamoDB stream ARN, or null when streams are disabled. |
| <a name="output_stream_label"></a> [stream\_label](#output\_stream\_label) | Latest DynamoDB stream label. |
| <a name="output_table_arn"></a> [table\_arn](#output\_table\_arn) | DynamoDB table ARN. |
| <a name="output_table_id"></a> [table\_id](#output\_table\_id) | DynamoDB table ID. |
| <a name="output_table_name"></a> [table\_name](#output\_table\_name) | Resolved table name. |
<!-- END_TF_DOCS -->
