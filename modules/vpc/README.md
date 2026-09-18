# VPC module

Creates a VPC with a map of public and private subnets, explicit route tables,
an optional internet gateway, and optional per-Availability-Zone NAT gateways.
This combines the Azure template's `vnet`, `subnet`, and `route_table` building
blocks in the form most commonly composed in AWS.

```hcl
module "vpc" {
  source = "../../modules/vpc"

  workload   = "platform"
  region_code = "use1"
  environment = "dev"
  cidr_block  = "10.20.0.0/16"

  nat_gateway_mode = "per_az"

  subnets = {
    public-a  = { cidr_block = "10.20.0.0/24", availability_zone = "us-east-1a", public = true }
    private-a = { cidr_block = "10.20.10.0/24", availability_zone = "us-east-1a" }
  }
}
```

`nat_gateway_mode` is explicit: `none` (default), `single` (lower cost and a
cross-AZ failure dependency), or `per_az` (recommended for resilient production
egress). The module fails rather than silently leaving a requested per-AZ NAT
topology incomplete. IPv6 and externally owned VPC Flow Log destinations are
also supported.
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
| [aws_egress_only_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/egress_only_internet_gateway) | resource |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_flow_log.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.private_ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.private_nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_ipv4](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assign_generated_ipv6_cidr_block"></a> [assign\_generated\_ipv6\_cidr\_block](#input\_assign\_generated\_ipv6\_cidr\_block) | Request an Amazon-provided /56 IPv6 CIDR for the VPC. | `bool` | `false` | no |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | IPv4 CIDR assigned to the VPC. | `string` | n/a | yes |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Enable DNS hostnames. Requires enable\_dns\_support. | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Enable Amazon-provided DNS resolution. | `bool` | `true` | no |
| <a name="input_enable_internet_gateway"></a> [enable\_internet\_gateway](#input\_enable\_internet\_gateway) | Create and attach an internet gateway. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_flow_log"></a> [flow\_log](#input\_flow\_log) | Optional VPC Flow Log configuration. The destination and IAM role are owned by the root security/logging composition. | <pre>object({<br>    enabled                  = optional(bool, false)<br>    destination_arn          = optional(string)<br>    destination_type         = optional(string, "cloud-watch-logs")<br>    iam_role_arn             = optional(string)<br>    traffic_type             = optional(string, "ALL")<br>    max_aggregation_interval = optional(number, 600)<br>    log_format               = optional(string)<br>  })</pre> | `{}` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags supplied by the root composition. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_instance_tenancy"></a> [instance\_tenancy](#input\_instance\_tenancy) | VPC instance tenancy. | `string` | `"default"` | no |
| <a name="input_name"></a> [name](#input\_name) | Explicit VPC name. When empty, the standard name is generated. | `string` | `""` | no |
| <a name="input_nat_gateway_mode"></a> [nat\_gateway\_mode](#input\_nat\_gateway\_mode) | NAT topology for private subnet IPv4 egress: none, single, or one gateway per Availability Zone. | `string` | `"none"` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short region code, for example use1. | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets keyed by stable logical name. ipv6\_prefix\_index allocates a /64 from the VPC-generated /56. | <pre>map(object({<br>    cidr_block              = string<br>    availability_zone       = string<br>    public                  = optional(bool, false)<br>    map_public_ip_on_launch = optional(bool, false)<br>    ipv6_prefix_index       = optional(number)<br>    assign_ipv6_on_creation = optional(bool, false)<br>    tags                    = optional(map(string), {})<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | VPC-specific tags merged over inherited\_tags. | `map(string)` | `{}` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload or application identifier used in generated names. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_flow_log_id"></a> [flow\_log\_id](#output\_flow\_log\_id) | VPC Flow Log ID, or null when flow logging is disabled. |
| <a name="output_ipv6_cidr_block"></a> [ipv6\_cidr\_block](#output\_ipv6\_cidr\_block) | Amazon-provided VPC IPv6 CIDR, or null when IPv6 is disabled. |
| <a name="output_name"></a> [name](#output\_name) | Resolved VPC name. |
| <a name="output_nat_gateway_ids"></a> [nat\_gateway\_ids](#output\_nat\_gateway\_ids) | NAT gateway IDs keyed by public subnet name. |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | Private subnet IDs keyed by logical subnet name. |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | Public subnet IDs keyed by logical subnet name. |
| <a name="output_route_table_ids"></a> [route\_table\_ids](#output\_route\_table\_ids) | Public and private route table IDs. |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | Subnet IDs keyed by logical subnet name. |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | VPC ARN. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID. |
<!-- END_TF_DOCS -->
