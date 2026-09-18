# EC2 instance module

Creates one hardened EC2 instance. AMI selection, networking, IAM permissions,
and security-group rules remain explicit root-composition responsibilities.

Secure defaults require IMDSv2, encrypt the root EBS volume, enable detailed
monitoring and termination protection, and do not assign a public address.
Production additionally rejects public IP addresses or disabled termination
protection.

```hcl
module "app_instance" {
  source = "../../modules/ec2_instance"

  ami_id                    = "ami-0123456789abcdef0"
  instance_type             = "t3.small"
  subnet_id                 = module.vpc.private_subnet_ids["private-a"]
  security_group_ids        = [module.security_group.security_group_id]
  iam_instance_profile_name = module.iam_role.instance_profile_name
  region_code               = "use1"
}
```

Prefer SSM Session Manager over SSH key pairs. Never place credentials in
`user_data`; Terraform state and instance metadata can expose that content.
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
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | Approved AMI ID. Resolve AMI selection in the root composition. | `string` | n/a | yes |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Associate a public IPv4 address. Disabled by default. | `bool` | `false` | no |
| <a name="input_disable_api_termination"></a> [disable\_api\_termination](#input\_disable\_api\_termination) | Enable EC2 API termination protection. | `bool` | `true` | no |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | Enable EBS optimization when supported by the instance type. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_iam_instance_profile_name"></a> [iam\_instance\_profile\_name](#input\_iam\_instance\_profile\_name) | Optional IAM instance profile name. | `string` | `null` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags supplied by the root composition. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | EC2 instance type. | `string` | `"t3.micro"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Optional EC2 key pair name. Prefer SSM Session Manager over SSH keys. | `string` | `null` | no |
| <a name="input_metadata_options"></a> [metadata\_options](#input\_metadata\_options) | Instance Metadata Service controls. IMDSv2 is required by default. | <pre>object({<br>    http_endpoint               = optional(string, "enabled")<br>    http_tokens                 = optional(string, "required")<br>    http_put_response_hop_limit = optional(number, 1)<br>    instance_metadata_tags      = optional(string, "disabled")<br>  })</pre> | `{}` | no |
| <a name="input_monitoring"></a> [monitoring](#input\_monitoring) | Enable EC2 detailed monitoring. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Explicit instance name. When empty, the standard name is generated. | `string` | `""` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short AWS region code, for example use1. | `string` | n/a | yes |
| <a name="input_root_block_device"></a> [root\_block\_device](#input\_root\_block\_device) | Root EBS volume configuration. | <pre>object({<br>    volume_type           = optional(string, "gp3")<br>    volume_size           = optional(number, 20)<br>    iops                  = optional(number)<br>    throughput            = optional(number)<br>    encrypted             = optional(bool, true)<br>    kms_key_id            = optional(string)<br>    delete_on_termination = optional(bool, true)<br>  })</pre> | `{}` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | VPC security groups attached to the primary network interface. | `set(string)` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet in which to create the instance. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Instance-specific tags. | `map(string)` | `{}` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | Optional bootstrap data. Do not include secrets because user data is stored in Terraform state and instance metadata. | `string` | `null` | no |
| <a name="input_user_data_replace_on_change"></a> [user\_data\_replace\_on\_change](#input\_user\_data\_replace\_on\_change) | Replace the instance when user data changes. | `bool` | `true` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_zone"></a> [availability\_zone](#output\_availability\_zone) | Availability Zone containing the instance. |
| <a name="output_instance_arn"></a> [instance\_arn](#output\_instance\_arn) | EC2 instance ARN. |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | EC2 instance ID. |
| <a name="output_name"></a> [name](#output\_name) | Resolved instance name. |
| <a name="output_private_dns"></a> [private\_dns](#output\_private\_dns) | Private DNS name. |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | Primary private IPv4 address. |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | Public IPv4 address, or an empty value when none is assigned. |
<!-- END_TF_DOCS -->
