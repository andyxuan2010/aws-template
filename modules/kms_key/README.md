# KMS key module

AWS counterpart to the encryption-key responsibilities of Azure Key Vault. It
creates a customer-managed KMS key, an optional conventional alias, and optional
grants. Rotation is enabled and the deletion waiting period is 30 days by
default.

```hcl
module "kms" {
  source = "../../modules/kms_key"

  workload    = "platform"
  region_code = "use1"
  environment = "dev"
}
```

Supply `key_policy_json` when organization policy requires explicit
administrators or service principals. Be careful not to create a policy that
prevents future key administration. The module rejects incompatible key
specification, usage, and rotation combinations, and production keys must retain
the 30-day deletion window. Multi-Region replicas should be managed by a
separate regional composition with an explicitly aliased AWS provider.
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
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_grant.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_grant) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_customer_master_key_spec"></a> [customer\_master\_key\_spec](#input\_customer\_master\_key\_spec) | KMS key material specification. | `string` | `"SYMMETRIC_DEFAULT"` | no |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | Waiting period before scheduled key deletion. | `number` | `30` | no |
| <a name="input_description"></a> [description](#input\_description) | KMS key description. | `string` | `"Customer-managed key managed by Terraform"` | no |
| <a name="input_enable_alias"></a> [enable\_alias](#input\_enable\_alias) | Create an alias for the key. | `bool` | `true` | no |
| <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input\_enable\_key\_rotation) | Enable automatic key rotation. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_grants"></a> [grants](#input\_grants) | KMS grants keyed by stable grant name. | <pre>map(object({<br>    grantee_principal  = string<br>    operations         = set(string)<br>    retiring_principal = optional(string)<br>    constraints = optional(object({<br>      encryption_context_equals = optional(map(string))<br>      encryption_context_subset = optional(map(string))<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags supplied by the root composition. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Whether the KMS key is enabled. | `bool` | `true` | no |
| <a name="input_key_policy_json"></a> [key\_policy\_json](#input\_key\_policy\_json) | Optional KMS key policy JSON. AWS applies its default policy when null. | `string` | `null` | no |
| <a name="input_key_usage"></a> [key\_usage](#input\_key\_usage) | Intended cryptographic use. | `string` | `"ENCRYPT_DECRYPT"` | no |
| <a name="input_multi_region"></a> [multi\_region](#input\_multi\_region) | Create a multi-Region primary key. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Explicit key name used for the alias and Name tag. When empty, the standard name is generated. | `string` | `""` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short region code, for example use1. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Key-specific tags. | `map(string)` | `{}` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alias_arn"></a> [alias\_arn](#output\_alias\_arn) | KMS alias ARN, or null when no alias is created. |
| <a name="output_alias_name"></a> [alias\_name](#output\_alias\_name) | KMS alias name, or null when no alias is created. |
| <a name="output_key_arn"></a> [key\_arn](#output\_key\_arn) | KMS key ARN. |
| <a name="output_key_id"></a> [key\_id](#output\_key\_id) | KMS key ID. |
| <a name="output_name"></a> [name](#output\_name) | Resolved key name. |
<!-- END_TF_DOCS -->
