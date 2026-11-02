# VPC endpoints module

Creates AWS Gateway and Interface endpoints in an existing VPC. Use Gateway
endpoints for supported route-table based services such as S3 and DynamoDB;
use Interface endpoints for services reached through endpoint network
interfaces in private subnets.

See the [VPC Endpoints and Private DNS guide](../../docs/10-architecture/vpc-endpoints-and-private-dns.md)
for DNS, routing, endpoint-policy, and client-connectivity considerations.
See the [module architecture](docs/architecture.md) for endpoint traffic paths
and caller-owned components.

## Features

- Provides Interface and Gateway VPC endpoints.
- Defaults include Private DNS enabled for Interface endpoints; explicit subnet,
  security group, or route table associations.

## Resources Created

The primary managed resources include Interface and Gateway VPC endpoints. Optional
resources depend on module inputs; see the generated Terraform Reference for the full
inventory.

## Prerequisites and Dependencies

Configure AWS provider credentials in the calling root module. The VPC and
referenced subnet, route table, and security group resources must exist in the
same VPC and region as the endpoints.

## Provider Configuration

This module requires Terraform `>= 1.6.0` and `hashicorp/aws >= 5.0, < 7.0`. Configure
the provider, credentials, account, Region, and any aliases in the consuming root. This
child module contains no provider or backend configuration. See the generated Terraform
Reference for details.

## Basic Usage

```hcl
module "vpc_endpoints" {
  source = "../../modules/vpc_endpoints"

  vpc_id      = module.vpc.vpc_id
  region_code = "use1"

  endpoints = {
    s3 = {
      service_name    = "com.amazonaws.us-east-1.s3"
      type            = "Gateway"
      route_table_ids = module.vpc.private_route_table_ids
    }
    ssm = {
      service_name       = "com.amazonaws.us-east-1.ssm"
      subnet_ids         = module.vpc.private_subnet_ids
      security_group_ids = [module.endpoint_security_group.security_group_id]
    }
  }
}
```

## Important Behavior and Secure Defaults

- Each endpoint is keyed by a stable logical name. Renaming a key changes
  Terraform resource identity and may replace the endpoint.
- Interface endpoints default to private DNS enabled and require explicit
  private subnet and security group IDs. The security group must allow the
  required client traffic, commonly HTTPS (TCP 443).
- Gateway endpoints require route table IDs and do not use subnets or security
  groups. AWS adds service routes to each selected route table.
- Endpoint policies are optional and passed to AWS as provided. If omitted,
  AWS applies its service default, which generally permits full access subject
  to identity and resource policies. Supply a scoped policy when appropriate.
- Interface endpoints are billed per endpoint-hour and data processed. Gateway
  endpoints have no endpoint-hour charge, but normal data transfer charges may
  apply. Review current regional pricing before deploying at scale.
- This module does not create the VPC, subnets, route tables, security groups,
  DNS resolver rules, or endpoint policies.

## Naming and Tagging

Endpoint `Name` tags use the repository naming convention. Effective tags merge
`inherited_tags`, module `tags`, endpoint-specific tags, and the generated
`Name` tag in that order.

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
| [aws_vpc_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_endpoints"></a> [endpoints](#input\_endpoints) | VPC endpoints keyed by stable logical names. Supports Interface and Gateway endpoints. | <pre>map(object({<br>    service_name        = string<br>    type                = optional(string, "Interface")<br>    subnet_ids          = optional(set(string), [])<br>    security_group_ids  = optional(set(string), [])<br>    route_table_ids     = optional(set(string), [])<br>    private_dns_enabled = optional(bool, true)<br>    policy              = optional(string)<br>    tags                = optional(map(string), {})<br>  }))</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags supplied by the root composition. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short region code, for example use1. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource-specific tags applied to all endpoints. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC in which to create the endpoints. | `string` | n/a | yes |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload or platform identifier used in endpoint Name tags. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_entries"></a> [dns\_entries](#output\_dns\_entries) | Interface endpoint DNS entries keyed by endpoint name. Gateway endpoints return empty lists. |
| <a name="output_endpoint_arns"></a> [endpoint\_arns](#output\_endpoint\_arns) | VPC endpoint ARNs keyed by endpoint name. |
| <a name="output_endpoint_ids"></a> [endpoint\_ids](#output\_endpoint\_ids) | VPC endpoint IDs keyed by endpoint name. |
| <a name="output_network_interface_ids"></a> [network\_interface\_ids](#output\_network\_interface\_ids) | Interface endpoint network interface IDs keyed by endpoint name. Gateway endpoints return empty lists. |
| <a name="output_prefix_list_ids"></a> [prefix\_list\_ids](#output\_prefix\_list\_ids) | Gateway endpoint prefix list IDs keyed by endpoint name. Interface endpoints return null. |
<!-- END_TF_DOCS -->
