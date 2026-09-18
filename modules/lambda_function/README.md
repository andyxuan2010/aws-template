# Lambda function module

Creates a Lambda function from exactly one local ZIP, S3 ZIP, or container image
source. The execution role remains external so IAM policy ownership stays
explicit.

Secure defaults publish immutable versions, enable active X-Ray tracing, prefer
ARM64, and avoid environment variables unless supplied. Do not place secrets in
`environment_variables`; retrieve Secrets Manager values at runtime.

```hcl
module "processor" {
  source = "../../modules/lambda_function"

  region_code = "use1"
  role_arn    = module.lambda_role.role_arn
  filename    = "build/processor.zip"
  runtime     = "python3.13"
  handler     = "handler.main"
  source_code_hash = filebase64sha256("build/processor.zip")
}
```

Use `code_signing_config_arn` for organizations that require signed ZIP
artifacts. Add a dead-letter destination for asynchronous production workloads.
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
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_architectures"></a> [architectures](#input\_architectures) | Function instruction-set architecture. | `list(string)` | <pre>[<br>  "arm64"<br>]</pre> | no |
| <a name="input_code_signing_config_arn"></a> [code\_signing\_config\_arn](#input\_code\_signing\_config\_arn) | Optional Lambda code-signing configuration ARN. | `string` | `null` | no |
| <a name="input_dead_letter_target_arn"></a> [dead\_letter\_target\_arn](#input\_dead\_letter\_target\_arn) | Optional SQS queue or SNS topic ARN for failed asynchronous invocations. | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Function description. | `string` | `"Managed by Terraform"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Non-secret environment variables. Store secrets in Secrets Manager and reference them at runtime. | `map(string)` | `{}` | no |
| <a name="input_ephemeral_storage_size"></a> [ephemeral\_storage\_size](#input\_ephemeral\_storage\_size) | Ephemeral storage in MiB. | `number` | `512` | no |
| <a name="input_filename"></a> [filename](#input\_filename) | Local ZIP archive path. | `string` | `null` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | Lambda handler for Zip packages. | `string` | `null` | no |
| <a name="input_image_uri"></a> [image\_uri](#input\_image\_uri) | Container image URI when package\_type is Image. | `string` | `null` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | Optional KMS key used to encrypt environment variables. | `string` | `null` | no |
| <a name="input_layers"></a> [layers](#input\_layers) | Lambda layer version ARNs. | `list(string)` | `[]` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Memory in MiB. | `number` | `256` | no |
| <a name="input_name"></a> [name](#input\_name) | Explicit function name. When empty, the standard name is generated. | `string` | `""` | no |
| <a name="input_package_type"></a> [package\_type](#input\_package\_type) | Lambda deployment package type. | `string` | `"Zip"` | no |
| <a name="input_publish"></a> [publish](#input\_publish) | Publish a new immutable function version. | `bool` | `true` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short AWS region code. | `string` | n/a | yes |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | Reserved concurrency. Null uses unreserved account concurrency. | `number` | `null` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | Execution role ARN. | `string` | n/a | yes |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Lambda runtime for Zip packages. | `string` | `null` | no |
| <a name="input_s3_package"></a> [s3\_package](#input\_s3\_package) | Optional S3 deployment package. | <pre>object({<br>    bucket         = string<br>    key            = string<br>    object_version = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_source_code_hash"></a> [source\_code\_hash](#input\_source\_code\_hash) | Base64 SHA-256 of a ZIP package. Strongly recommended for deterministic updates. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Function-specific tags. | `map(string)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Execution timeout in seconds. | `number` | `30` | no |
| <a name="input_tracing_mode"></a> [tracing\_mode](#input\_tracing\_mode) | X-Ray tracing mode. | `string` | `"Active"` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Optional VPC attachment. | <pre>object({<br>    subnet_ids         = set(string)<br>    security_group_ids = set(string)<br>    ipv6_allowed       = optional(bool, false)<br>  })</pre> | `null` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | Unqualified function ARN. |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | Resolved Lambda function name. |
| <a name="output_invoke_arn"></a> [invoke\_arn](#output\_invoke\_arn) | ARN used to invoke the function from API Gateway. |
| <a name="output_last_modified"></a> [last\_modified](#output\_last\_modified) | Timestamp of the last function modification. |
| <a name="output_qualified_arn"></a> [qualified\_arn](#output\_qualified\_arn) | Version-qualified function ARN when publish is enabled. |
| <a name="output_version"></a> [version](#output\_version) | Published function version. |
<!-- END_TF_DOCS -->
