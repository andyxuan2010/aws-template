# Security group module

AWS counterpart to the Azure template's `nsg` module. It creates one security
group and uses standalone rule resources to avoid rule ownership conflicts.
Ingress and egress are both denied by default. Callers must declare the exact
destinations a workload requires.

```hcl
module "app_sg" {
  source = "../../modules/security_group"

  vpc_id      = module.vpc.vpc_id
  region_code = "use1"
  ingress_rules = {
    https = {
      ip_protocol = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_ipv4   = "10.20.0.0/16"
    }
  }
}
```

Each rule must specify exactly one IPv4 CIDR, IPv6 CIDR, prefix list, or
referenced security group. Public ingress from `0.0.0.0/0` or `::/0` is rejected
unless `allow_public_ingress = true` is explicitly set. Protocol-specific rules
must define a valid port range.
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
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_public_ingress"></a> [allow\_public\_ingress](#input\_allow\_public\_ingress) | Explicitly allow ingress rules sourced from all IPv4 or IPv6 addresses. | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | Security group description. | `string` | `"Managed by Terraform"` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | Egress rules keyed by a stable logical name. | <pre>map(object({<br>    description                  = optional(string)<br>    ip_protocol                  = string<br>    from_port                    = optional(number)<br>    to_port                      = optional(number)<br>    cidr_ipv4                    = optional(string)<br>    cidr_ipv6                    = optional(string)<br>    prefix_list_id               = optional(string)<br>    referenced_security_group_id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | Ingress rules keyed by a stable logical name. | <pre>map(object({<br>    description                  = optional(string)<br>    ip_protocol                  = string<br>    from_port                    = optional(number)<br>    to_port                      = optional(number)<br>    cidr_ipv4                    = optional(string)<br>    cidr_ipv6                    = optional(string)<br>    prefix_list_id               = optional(string)<br>    referenced_security_group_id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags supplied by the root composition. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_name"></a> [name](#input\_name) | Explicit security group name. When empty, the standard name is generated. | `string` | `""` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short region code, for example use1. | `string` | n/a | yes |
| <a name="input_revoke_rules_on_delete"></a> [revoke\_rules\_on\_delete](#input\_revoke\_rules\_on\_delete) | Revoke attached rules before deleting the security group. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource-specific tags. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC in which to create the security group. | `string` | n/a | yes |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_egress_rule_ids"></a> [egress\_rule\_ids](#output\_egress\_rule\_ids) | Egress rule IDs keyed by logical rule name. |
| <a name="output_ingress_rule_ids"></a> [ingress\_rule\_ids](#output\_ingress\_rule\_ids) | Ingress rule IDs keyed by logical rule name. |
| <a name="output_name"></a> [name](#output\_name) | Resolved security group name. |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | Security group ARN. |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Security group ID. |
<!-- END_TF_DOCS -->
