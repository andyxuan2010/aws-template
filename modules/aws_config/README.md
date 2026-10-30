# AWS Config module

Creates a regional AWS Config recorder, delivery channel, recorder IAM role,
and dedicated S3 destination. By default, the recorder continuously
records all supported regional resource types and delivers recurring snapshots
to the bucket every 24 hours.

See the [AWS Config module architecture](docs/architecture.md) for recorder,
delivery, encryption, and regional ownership relationships.

## Features

- Provides AWS Config recorder, delivery channel, IAM role, and S3 history bucket.
- Defaults include Continuous recording; full resource coverage; global resource capture
  opt-in; private encrypted delivery bucket.

## Resources Created

The primary managed resources include AWS Config recorder, delivery channel, IAM role,
and S3 history bucket. Optional resources depend on module inputs; see the generated
Terraform Reference for the full inventory.

## Prerequisites and Dependencies

Configure AWS credentials and the provider Region in the calling root module.
Set `region` to the provider's Region so the bucket and role policies are
restricted to the correct AWS Config source ARN. The caller needs permission to
manage AWS Config, IAM roles and attachments, S3 buckets and policies, and the
supplied KMS key. See [AWS Config KMS key policy guidance](https://docs.aws.amazon.com/config/latest/developerguide/s3-kms-key-policy.html).

## Provider Configuration

This module requires Terraform `>= 1.6.0` and `hashicorp/aws >= 5.0, < 7.0`. Configure
the provider, credentials, account, Region, and any aliases in the consuming root. This
child module contains no provider or backend configuration. See the generated Terraform
Reference for details.

## Basic Usage

```hcl
module "aws_config" {
  source = "../../modules/aws_config"

  region_code = "use1"
  region      = "us-east-1"
  environment = "prod"
  workload    = "platform"
  kms_key_arn = var.audit_kms_key_arn

  # Enable only in the designated Region for global IAM resource recording.
  include_global_resource_types = true
}
```

## Important Behavior and Secure Defaults

- AWS Config allows one delivery channel and one configuration recorder per
  account and Region. This module uses the default names and manages them as a
  single regional unit.
- The recorder role has the AWS managed `AWS_ConfigRole` policy for read access
  to supported resource configurations plus an inline policy scoped to the
  module's log bucket. The bucket and delivery channel use the supplied
  customer-managed KMS key, with versioning, all public access blocks, and a
  TLS-only policy.
- Global resource types are excluded by default. Enable them only in a
  designated Region to avoid duplicate global resource recording.
- Continuous recording and full resource coverage are enabled by default.
  Recording a selected resource type set or using daily recording can reduce
  coverage and change configuration history freshness.
- The bucket retains configuration history indefinitely and cannot be deleted
  while it contains objects because `force_destroy` is disabled. S3 storage,
  AWS Config configuration item recording, and rule evaluations incur charges.
- This module does not create or manage the KMS key. Supply a symmetric key in
  the same Region and allow `config.amazonaws.com` to use `kms:Decrypt` and
  `kms:GenerateDataKey` in its key policy. The key policy should scope access to
  the account and Config source ARN. Config rules, aggregators, organization
  delegated-administrator setup, SNS notifications, and cross-account delivery
  are composed separately.

## Naming and Tagging

The recorder and role use the repository naming convention. The dedicated
bucket name includes the AWS account ID. Tags on the IAM role and bucket merge
inherited tags, module tags, and the generated `Name` tag. AWS Config recorder
resources do not support tags.

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
| [aws_config_configuration_recorder.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder) | resource |
| [aws_config_configuration_recorder_status.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder_status) | resource |
| [aws_config_delivery_channel.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_delivery_channel) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.bucket_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.config_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
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
| <a name="input_include_global_resource_types"></a> [include\_global\_resource\_types](#input\_include\_global\_resource\_types) | Include global resource types. Enable only in the designated Region for global resource recording. | `bool` | `false` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags supplied by the root composition. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | ARN of the customer-managed KMS key used to encrypt AWS Config objects and delivery channel data. | `string` | n/a | yes |
| <a name="input_record_all_supported"></a> [record\_all\_supported](#input\_record\_all\_supported) | Record all supported resource types, including new types as AWS Config supports them. | `bool` | `true` | no |
| <a name="input_recording_frequency"></a> [recording\_frequency](#input\_recording\_frequency) | Configuration recording frequency. Continuous recording is the default for prompt change capture. | `string` | `"CONTINUOUS"` | no |
| <a name="input_recording_resource_types"></a> [recording\_resource\_types](#input\_recording\_resource\_types) | Resource types to record when record\_all\_supported is false. | `set(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region name matching the provider region, for example us-east-1. | `string` | n/a | yes |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short region code used in generated names, for example use1. | `string` | n/a | yes |
| <a name="input_s3_key_prefix"></a> [s3\_key\_prefix](#input\_s3\_key\_prefix) | Prefix for AWS Config history and snapshots in the dedicated S3 bucket. | `string` | `"config"` | no |
| <a name="input_snapshot_delivery_frequency"></a> [snapshot\_delivery\_frequency](#input\_snapshot\_delivery\_frequency) | Frequency for recurring configuration snapshots delivered to S3. | `string` | `"TwentyFour_Hours"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource-specific tags. | `map(string)` | `{}` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Lowercase workload identifier used in generated resource names. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | ARN of the dedicated AWS Config S3 bucket. |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | Name of the dedicated encrypted S3 bucket that stores configuration history and snapshots. |
| <a name="output_delivery_channel_name"></a> [delivery\_channel\_name](#output\_delivery\_channel\_name) | AWS Config delivery channel name. |
| <a name="output_recorder_name"></a> [recorder\_name](#output\_recorder\_name) | AWS Config recorder name. |
| <a name="output_recorder_role_arn"></a> [recorder\_role\_arn](#output\_recorder\_role\_arn) | IAM role ARN used by the AWS Config recorder. |
<!-- END_TF_DOCS -->
