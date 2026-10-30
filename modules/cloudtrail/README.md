# CloudTrail module

Creates a multi-region CloudTrail with global service events, log file
validation, and a dedicated encrypted S3 destination. Its S3 bucket has
versioning, public access blocks, TLS enforcement, and a restricted CloudTrail
delivery policy.

See the [CloudTrail module architecture](docs/architecture.md) for log delivery,
encryption, and caller-owned security boundaries.

## Features

- Provides Multi-region CloudTrail and dedicated S3 log bucket.
- Defaults include Global service events; log file validation; encrypted, versioned,
  private bucket with TLS-only policy.

## Resources Created

The primary managed resources include Multi-region CloudTrail and dedicated S3 log
bucket. Optional resources depend on module inputs; see the generated Terraform
Reference for the full inventory.

## Prerequisites and Dependencies

Configure AWS credentials and the provider region in the calling root module.
Set `region` to the same Region configured on the provider.
The caller needs permission to create CloudTrail trails, S3 buckets and bucket
policies, and use the supplied KMS key, as well as the account and partition
data sources used by the module. See [CloudTrail KMS key policy guidance](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/create-kms-key-policy-for-cloudtrail.html).

## Provider Configuration

This module requires Terraform `>= 1.6.0` and `hashicorp/aws >= 5.0, < 7.0`. Configure
the provider, credentials, account, Region, and any aliases in the consuming root. This
child module contains no provider or backend configuration. See the generated Terraform
Reference for details.

## Basic Usage

```hcl
module "cloudtrail" {
  source = "../../modules/cloudtrail"

  region_code = "use1"
  region      = "us-east-1"
  environment = "prod"
  workload    = "platform"
  kms_key_arn = var.audit_kms_key_arn

  tags = {
    DataClassification = "audit"
  }
}
```

## Important Behavior and Secure Defaults

- The trail is multi-region, includes global service events, enables log file
  validation, and starts logging by default.
- The dedicated log bucket has S3 versioning, server-side encryption, all S3
  public access blocks, a TLS-only policy, and a restricted CloudTrail service
  write policy. The bucket and trail use the supplied customer-managed KMS key.
  Bucket deletion fails while objects remain because `force_destroy` is
  disabled.
- The generated bucket name includes the AWS account ID. CloudTrail log files
  are retained indefinitely unless a lifecycle policy is added separately.
  Storage, requests, and data retrieval incur S3 charges.
- CloudTrail event copies, data events, and Insights are not enabled by this
  module; each can add volume and cost. Add selectors deliberately for the
  resources that need them.
- Set `is_organization_trail = true` only from an AWS Organizations management
  or delegated administrator account with organization trail permissions. The
  organization, delegated administration, and member account setup are outside
  this module.
- This module does not create or manage the KMS key. Supply a symmetric key in
  the trail's home Region. Its key policy must allow `cloudtrail.amazonaws.com`
  to use `kms:GenerateDataKey*` and `kms:DescribeKey`, scoped to this trail ARN.
  Add decrypt access for the principals that need to read the logs. CloudWatch
  Logs delivery is outside this module.

## Naming and Tagging

The default trail name follows the repository naming convention. The log
bucket name includes the AWS account ID to reduce global name collisions. Tags
merge inherited tags, module tags, and the generated `Name` tag.

## Testing

```powershell
terraform init -backend=false
terraform validate
terraform test
```

Tests use mocked providers and do not create AWS resources.

## Terraform Reference

The content below is generated from module source. Do not edit it manually.

<!-- BEGIN_TF_DOCS -->## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.70.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_ownership_controls.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags supplied by the root composition. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_is_organization_trail"></a> [is\_organization\_trail](#input\_is\_organization\_trail) | Create an organization trail. Requires Organizations setup and suitable permissions in the calling account. | `bool` | `false` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | ARN of the customer-managed KMS key used to encrypt CloudTrail log objects. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Optional explicit CloudTrail name. When empty, the standard name is generated. | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region name matching the provider region, for example us-east-1. | `string` | n/a | yes |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short region code, for example use1. | `string` | n/a | yes |
| <a name="input_s3_key_prefix"></a> [s3\_key\_prefix](#input\_s3\_key\_prefix) | Prefix for CloudTrail log objects in the dedicated S3 bucket. | `string` | `"cloudtrail"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource-specific tags. | `map(string)` | `{}` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Lowercase workload identifier used in generated names. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_log_bucket_arn"></a> [log\_bucket\_arn](#output\_log\_bucket\_arn) | ARN of the dedicated S3 log bucket. |
| <a name="output_log_bucket_name"></a> [log\_bucket\_name](#output\_log\_bucket\_name) | Name of the dedicated, encrypted S3 log bucket. |
| <a name="output_trail_arn"></a> [trail\_arn](#output\_trail\_arn) | CloudTrail ARN. |
| <a name="output_trail_home_region"></a> [trail\_home\_region](#output\_trail\_home\_region) | Region where the CloudTrail resource is managed. |
| <a name="output_trail_name"></a> [trail\_name](#output\_trail\_name) | Resolved CloudTrail name. |
<!-- END_TF_DOCS -->
