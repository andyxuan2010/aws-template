# S3 bucket module

AWS counterpart to the Azure template's `storageaccount` module. Secure defaults
enable encryption, versioning, S3 Object Ownership, all four public-access
blocks, and a policy denying requests that do not use TLS.

```hcl
module "logs" {
  source = "../../modules/s3_bucket"

  # Include an organization/account discriminator for global uniqueness.
  name        = "s3-acme-platform-use1-dev-001"
  region_code = "use1"
  kms_key_arn = module.kms.key_arn

  lifecycle_rules = {
    retention = {
      noncurrent_version_expiration   = 90
      abort_incomplete_multipart_days = 7
    }
  }
}
```

`force_destroy` defaults to false and is rejected in `prod`. A custom policy can
be supplied as JSON and is merged with the TLS enforcement statement. Optional
server access logging and Object Lock retention are supported. Object Lock is an
irreversible bucket capability and should be selected before initial creation.
MFA Delete is intentionally not exposed because normal automation roles cannot
reliably administer it; use a separately governed root-account procedure if the
control is required.
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
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_object_lock_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) | resource |
| [aws_s3_bucket_ownership_controls.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_iam_policy_document.combined](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.tls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logging"></a> [access\_logging](#input\_access\_logging) | Optional server access logging destination. Use a separate log bucket to avoid recursive logging. | <pre>object({<br>    target_bucket = string<br>    target_prefix = optional(string, "access-logs/")<br>  })</pre> | `null` | no |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Block public ACLs. | `bool` | `true` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Block public bucket policies. | `bool` | `true` | no |
| <a name="input_bucket_key_enabled"></a> [bucket\_key\_enabled](#input\_bucket\_key\_enabled) | Use an S3 Bucket Key when SSE-KMS is enabled. | `bool` | `true` | no |
| <a name="input_bucket_policy_json"></a> [bucket\_policy\_json](#input\_bucket\_policy\_json) | Optional additional IAM policy document to merge with the TLS policy. | `string` | `null` | no |
| <a name="input_enforce_tls"></a> [enforce\_tls](#input\_enforce\_tls) | Attach a bucket policy that denies non-TLS requests. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Allow deletion of a non-empty bucket. Keep false for durable environments. | `bool` | `false` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Ignore public ACLs. | `bool` | `true` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags supplied by the root composition. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | KMS key ARN for SSE-KMS. When null, SSE-S3 AES256 encryption is used. | `string` | `null` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | Lifecycle rules keyed by stable rule ID. | <pre>map(object({<br>    enabled                         = optional(bool, true)<br>    prefix                          = optional(string)<br>    expiration_days                 = optional(number)<br>    noncurrent_version_expiration   = optional(number)<br>    abort_incomplete_multipart_days = optional(number)<br>  }))</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Explicit globally unique bucket name. When empty, the standard name is generated. | `string` | `""` | no |
| <a name="input_object_lock"></a> [object\_lock](#input\_object\_lock) | Optional S3 Object Lock default retention. Enabling Object Lock is an irreversible bucket capability. | <pre>object({<br>    enabled        = optional(bool, false)<br>    mode           = optional(string, "GOVERNANCE")<br>    retention_days = optional(number, 30)<br>  })</pre> | `{}` | no |
| <a name="input_object_ownership"></a> [object\_ownership](#input\_object\_ownership) | S3 Object Ownership mode. | `string` | `"BucketOwnerEnforced"` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short region code, for example use1. | `string` | n/a | yes |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Restrict public bucket policies. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Bucket-specific tags. | `map(string)` | `{}` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | Enable S3 object versioning. | `bool` | `true` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | Bucket ARN. |
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | Bucket domain name. |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | Bucket name. |
| <a name="output_bucket_regional_domain_name"></a> [bucket\_regional\_domain\_name](#output\_bucket\_regional\_domain\_name) | Regional bucket domain name. |
| <a name="output_name"></a> [name](#output\_name) | Resolved bucket name. |
| <a name="output_object_lock_enabled"></a> [object\_lock\_enabled](#output\_object\_lock\_enabled) | Whether Object Lock was enabled when the bucket was created. |
<!-- END_TF_DOCS -->
