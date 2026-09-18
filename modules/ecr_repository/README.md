# ECR repository module

Creates an encrypted ECR repository with immutable tags, scan-on-push, and a
default lifecycle policy. Untagged images expire after 14 days and the most
recent 50 tagged images are retained.

```hcl
module "repository" {
  source = "../../modules/ecr_repository"

  region_code    = "use1"
  encryption_type = "KMS"
  kms_key_arn     = module.kms.key_arn
}
```

Production rejects mutable tags, disabled scanning, and destructive
`force_delete`. Cross-account access must be granted through an explicit
repository policy.
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
| [aws_ecr_lifecycle_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_encryption_type"></a> [encryption\_type](#input\_encryption\_type) | Repository encryption type. | `string` | `"AES256"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_force_delete"></a> [force\_delete](#input\_force\_delete) | Delete images when destroying the repository. | `bool` | `false` | no |
| <a name="input_image_tag_mutability"></a> [image\_tag\_mutability](#input\_image\_tag\_mutability) | Whether image tags can be overwritten. | `string` | `"IMMUTABLE"` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | KMS key ARN required when encryption\_type is KMS. | `string` | `null` | no |
| <a name="input_lifecycle_policy_json"></a> [lifecycle\_policy\_json](#input\_lifecycle\_policy\_json) | Optional complete ECR lifecycle policy JSON. The secure default expires untagged images after 14 days and retains 50 tagged images. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Explicit repository name. When empty, the standard name is generated. | `string` | `""` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short AWS region code. | `string` | n/a | yes |
| <a name="input_repository_policy_json"></a> [repository\_policy\_json](#input\_repository\_policy\_json) | Optional ECR repository policy JSON. | `string` | `null` | no |
| <a name="input_scan_on_push"></a> [scan\_on\_push](#input\_scan\_on\_push) | Scan images when pushed. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Repository-specific tags. | `map(string)` | `{}` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_registry_id"></a> [registry\_id](#output\_registry\_id) | Registry account ID. |
| <a name="output_repository_arn"></a> [repository\_arn](#output\_repository\_arn) | Repository ARN. |
| <a name="output_repository_name"></a> [repository\_name](#output\_repository\_name) | Resolved repository name. |
| <a name="output_repository_url"></a> [repository\_url](#output\_repository\_url) | Registry URL used for image pushes and pulls. |
<!-- END_TF_DOCS -->
