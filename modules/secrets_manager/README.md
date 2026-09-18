# Secrets Manager module

Creates secret metadata, optional replicas, an optional resource policy, and
optional Lambda-based rotation. It intentionally does not create a secret
version or accept secret values, because Terraform would persist those values
in state.

```hcl
module "database_secret" {
  source = "../../modules/secrets_manager"

  region_code = "use1"
  kms_key_id  = module.kms.key_arn

  rotation = {
    lambda_arn              = module.rotation.function_arn
    automatically_after_days = 30
  }
}
```

Populate the value through an approved out-of-band workflow or allow a service
such as RDS to own its generated credential. Production enforces the maximum
30-day deletion recovery window. Public resource policies are blocked by
default.
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
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_policy) | resource |
| [aws_secretsmanager_secret_rotation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Reject policies that grant broad public access. | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Secret purpose and ownership description. | `string` | `"Secret metadata managed by Terraform"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_force_overwrite_replica_secret"></a> [force\_overwrite\_replica\_secret](#input\_force\_overwrite\_replica\_secret) | Allow replica creation to overwrite a same-named replica secret. | `bool` | `false` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | Optional customer-managed KMS key ARN or ID. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Explicit secret name. When empty, the standard name is generated. | `string` | `""` | no |
| <a name="input_recovery_window_in_days"></a> [recovery\_window\_in\_days](#input\_recovery\_window\_in\_days) | Recovery window before permanent secret deletion. | `number` | `30` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short AWS region code. | `string` | n/a | yes |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | Replica definitions keyed by stable logical name. | <pre>map(object({<br>    region     = string<br>    kms_key_id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_resource_policy_json"></a> [resource\_policy\_json](#input\_resource\_policy\_json) | Optional resource-based policy JSON. | `string` | `null` | no |
| <a name="input_rotation"></a> [rotation](#input\_rotation) | Optional Lambda-based rotation configuration. | <pre>object({<br>    lambda_arn               = string<br>    automatically_after_days = optional(number, 30)<br>    duration                 = optional(string)<br>    schedule_expression      = optional(string)<br>    rotate_immediately       = optional(bool, false)<br>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Secret-specific tags. | `map(string)` | `{}` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | Resolved secret name. |
| <a name="output_replica_status"></a> [replica\_status](#output\_replica\_status) | Replication status reported by Secrets Manager. |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | Secret ARN. |
| <a name="output_secret_id"></a> [secret\_id](#output\_secret\_id) | Secret ID. |
<!-- END_TF_DOCS -->
