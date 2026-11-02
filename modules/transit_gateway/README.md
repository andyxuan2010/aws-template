# Transit Gateway module

Creates an AWS Transit Gateway, VPC attachments, explicitly associated route
tables, optional route propagation, and static IPv4 or IPv6 routes. Use the module to
connect VPCs through a shared network hub while keeping routing decisions
declarative.

See the [Transit Gateway module architecture](docs/architecture.md) for
attachment, route table, and caller-owned VPC routing relationships.

## Features

- Provides Transit Gateway, VPC attachments, route tables, static routes.
- Defaults include Default route association and propagation disabled; explicit
  associations and propagation.

## Resources Created

The primary managed resources include Transit Gateway, VPC attachments, route tables,
static routes. Optional resources depend on module inputs; see the generated Terraform
Reference for the full inventory.

## Prerequisites and Dependencies

Configure AWS provider credentials in the calling root module. Referenced VPCs
and subnets must exist in the same region and be routable through the selected
Transit Gateway attachments. Provide security and network policy separately.

## Provider Configuration

This module requires Terraform `>= 1.6.0` and `hashicorp/aws >= 5.0, < 7.0`. Configure
the provider, credentials, account, Region, and any aliases in the consuming root. This
child module contains no provider or backend configuration. See the generated Terraform
Reference for details.

## Basic Usage

```hcl
module "transit_gateway" {
  source = "../../modules/transit_gateway"

  region_code = "use1"

  route_tables = {
    workloads = {
      routes = {
        shared_services = {
          destination_cidr_block = "10.30.0.0/16"
          attachment_key         = "shared"
        }
      }
    }
    shared = {}
  }

  attachments = {
    workload = {
      vpc_id                      = module.workload_vpc.vpc_id
      subnet_ids                  = toset(values(module.workload_vpc.private_subnet_ids))
      route_table_key             = "workloads"
      propagated_route_table_keys = ["shared"]
    }
    shared = {
      vpc_id          = module.shared_vpc.vpc_id
      subnet_ids      = toset(values(module.shared_vpc.private_subnet_ids))
      route_table_key = "shared"
    }
  }
}
```

## Important Behavior and Secure Defaults

- At least one attachment and route table are required. Each attachment is
  explicitly associated with one declared route table; AWS's default route
  table association and propagation are disabled.
- VPC attachments need one subnet in each Availability Zone that should carry
  Transit Gateway traffic. AWS recommends attachment subnets in every AZ used
  by workloads. Attachment subnet route tables and workload subnet route tables
  still need routes to the Transit Gateway where traffic should flow.
- Route propagation is opt-in per attachment and route table. Static routes
  target another attachment by its stable map key. VPC CIDRs and routes must not
  overlap in ways that create ambiguous routing.
- The module creates only VPC attachments in the current account. AWS RAM
  sharing, cross-account attachment acceptance, VPN, Direct Connect, peering,
  Connect, multicast, and VPC subnet route updates are outside its scope.
- Transit Gateway has hourly attachment and data processing charges. Review
  regional pricing and expected traffic before deploying; removing an
  attachment or route can interrupt traffic.

## Naming and Tagging

Generated `Name` tags follow the repository naming convention. Effective tags
merge inherited tags, module tags, child resource tags, and the generated name
tag in that order.

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
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0, < 7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway) | resource |
| [aws_ec2_transit_gateway_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_ec2_transit_gateway_route_table_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_association) | resource |
| [aws_ec2_transit_gateway_route_table_propagation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_propagation) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_amazon_side_asn"></a> [amazon\_side\_asn](#input\_amazon\_side\_asn) | Private autonomous system number for the AWS side of the transit gateway. | `number` | `64512` | no |
| <a name="input_attachments"></a> [attachments](#input\_attachments) | VPC attachments keyed by stable logical names. Select one subnet per intended Availability Zone. | <pre>map(object({<br>    vpc_id                      = string<br>    subnet_ids                  = set(string)<br>    route_table_key             = string<br>    dns_support                 = optional(string, "enable")<br>    ipv6_support                = optional(string, "disable")<br>    appliance_mode_support      = optional(string, "disable")<br>    propagated_route_table_keys = optional(set(string), [])<br>    tags                        = optional(map(string), {})<br>  }))</pre> | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description for the transit gateway. | `string` | `"Managed by Terraform"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags supplied by the root composition. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short region code, for example use1. | `string` | n/a | yes |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables) | Transit gateway route tables keyed by stable logical names. Static routes target attachment keys. | <pre>map(object({<br>    description = optional(string)<br>    routes = optional(map(object({<br>      destination_cidr_block = string<br>      attachment_key         = string<br>    })), {})<br>    tags = optional(map(string), {})<br>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource-specific tags applied to the transit gateway. | `map(string)` | `{}` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload or platform identifier used in resource Name tags. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_attachment_ids"></a> [attachment\_ids](#output\_attachment\_ids) | VPC attachment IDs keyed by logical attachment name. |
| <a name="output_route_ids"></a> [route\_ids](#output\_route\_ids) | Static route IDs keyed by route table and route name. |
| <a name="output_route_table_ids"></a> [route\_table\_ids](#output\_route\_table\_ids) | Transit gateway route table IDs keyed by logical route table name. |
| <a name="output_transit_gateway_arn"></a> [transit\_gateway\_arn](#output\_transit\_gateway\_arn) | Transit gateway ARN. |
| <a name="output_transit_gateway_id"></a> [transit\_gateway\_id](#output\_transit\_gateway\_id) | Transit gateway ID. |
| <a name="output_transit_gateway_name"></a> [transit\_gateway\_name](#output\_transit\_gateway\_name) | Generated Transit Gateway Name tag. |
<!-- END_TF_DOCS -->
