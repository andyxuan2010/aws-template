# IAM role module

AWS counterpart to the Azure template's `managedidentity` and
`roleassignments` modules. It creates a role from an explicit trust policy,
attaches managed and inline policies, supports a permissions boundary, and can
create an EC2 instance profile.

```hcl
module "ec2_role" {
  source = "../../modules/iam_role"

  workload               = "platform"
  environment            = "dev"
  create_instance_profile = true
  trust_policy_statements = [{
    actions = ["sts:AssumeRole"]
    principals = [{
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }]
  }]
}
```

The typed trust-policy interface is preferred because it makes principals,
actions, and conditions reviewable. Raw JSON remains an advanced, mutually
exclusive escape hatch. The module does not invent trust relationships or
permissions. Root compositions must make both explicit and should use a
permissions boundary in multi-account landing zones.
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
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assume_role_policy_json"></a> [assume\_role\_policy\_json](#input\_assume\_role\_policy\_json) | Advanced escape hatch for a complete IAM trust policy JSON document. Mutually exclusive with trust\_policy\_statements. | `string` | `null` | no |
| <a name="input_create_instance_profile"></a> [create\_instance\_profile](#input\_create\_instance\_profile) | Create an EC2 instance profile for the role. | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | IAM role description. | `string` | `"Managed by Terraform"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags supplied by the root composition. | `map(string)` | `{}` | no |
| <a name="input_inline_policies"></a> [inline\_policies](#input\_inline\_policies) | Inline policy JSON documents keyed by policy name. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_instance_profile_name"></a> [instance\_profile\_name](#input\_instance\_profile\_name) | Optional instance profile name. Defaults to the role name. | `string` | `""` | no |
| <a name="input_managed_policy_arns"></a> [managed\_policy\_arns](#input\_managed\_policy\_arns) | Managed policy ARNs to attach. | `set(string)` | `[]` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum role session duration in seconds. | `number` | `3600` | no |
| <a name="input_name"></a> [name](#input\_name) | Explicit IAM role name. When empty, the standard global-resource name is generated. | `string` | `""` | no |
| <a name="input_path"></a> [path](#input\_path) | IAM path for the role. | `string` | `"/"` | no |
| <a name="input_permissions_boundary_arn"></a> [permissions\_boundary\_arn](#input\_permissions\_boundary\_arn) | Optional permissions boundary policy ARN. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Role-specific tags. | `map(string)` | `{}` | no |
| <a name="input_trust_policy_statements"></a> [trust\_policy\_statements](#input\_trust\_policy\_statements) | Typed IAM trust-policy statements. Prefer this over raw JSON for validation and reviewability. | <pre>list(object({<br>    sid     = optional(string)<br>    effect  = optional(string, "Allow")<br>    actions = set(string)<br>    principals = list(object({<br>      type        = string<br>      identifiers = set(string)<br>    }))<br>    conditions = optional(list(object({<br>      test     = string<br>      variable = string<br>      values   = set(string)<br>    })), [])<br>  }))</pre> | `[]` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_profile_arn"></a> [instance\_profile\_arn](#output\_instance\_profile\_arn) | Instance profile ARN, or null when not created. |
| <a name="output_instance_profile_name"></a> [instance\_profile\_name](#output\_instance\_profile\_name) | Instance profile name, or null when not created. |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | IAM role ARN. |
| <a name="output_role_id"></a> [role\_id](#output\_role\_id) | IAM role ID. |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | Resolved IAM role name. |
<!-- END_TF_DOCS -->
