# Route manager module

Manages AWS VPC routes that steer traffic through FortiGate network interfaces
or Gateway Load Balancer endpoints. The module supports a declarative primary
and secondary target switch for route failover, while keeping route-table
ownership and next-hop IDs explicit.

## FortiGate ENI example

```hcl
module "fortigate_routes" {
  source = "../../modules/route_manager"

  workload    = "edge"
  region_code = "use1"

  routes = {
    outbound = {
      route_table_id         = "rtb-0123456789abcdef0"
      destination_cidr_block = "0.0.0.0/0"
      target = {
        type = "network_interface_id"
        id   = "eni-0123456789abcdef0"
      }
    }
  }
}
```

For a native FortiGate active-passive HA pair, use the traffic or egress ENI
IDs appropriate for the route and provide the secondary target:

```hcl
failover = {
  active_target = "primary"
  secondary_target = {
    type = "network_interface_id"
    id   = "eni-0123456789abcdef1"
  }
}
```

Change `active_target` to `secondary` in a controlled Terraform change when
performing a declarative promotion. Terraform is not a runtime health monitor;
automatic route failover should be provided by FortiGate native HA/AWS SDN
integration or a separately operated automation service. Do not let both that
automation and this module manage the same route objects.

## GWLB endpoint example

For traffic inspection through the `gateway_load_balancer` module, route to the
GWLB endpoint created in the consumer VPC:

```hcl
target = {
  type = "vpc_endpoint_id"
  id   = "vpce-0123456789abcdef0"
}
```

## Dependencies and limitations

The caller owns VPCs, route tables, subnet associations, FortiGate instances
and ENIs, GWLB endpoints, transit gateways, and route-table propagation. This
module assumes exclusive ownership of each declared route destination in its
route table. It does not create route tables or validate that a next hop is
reachable in the target VPC. Route changes can interrupt traffic and should be
rolled out with a tested rollback path.

## Testing

```powershell
terraform init -backend=false
terraform validate
terraform test
```

Tests use mocked providers and do not apply AWS resources.

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
| [aws_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_name"></a> [name](#input\_name) | Explicit route manager name. When empty, the standard name is generated. | `string` | `""` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short AWS region code, for example use1. | `string` | n/a | yes |
| <a name="input_routes"></a> [routes](#input\_routes) | Routes keyed by stable logical name. Targets may be FortiGate network interfaces, GWLB VPC endpoints, transit gateways, NAT gateways, or other supported AWS route targets. | <pre>map(object({<br>    route_table_id              = string<br>    destination_cidr_block      = optional(string)<br>    destination_ipv6_cidr_block = optional(string)<br>    target = object({<br>      type = string<br>      id   = string<br>    })<br>    failover = optional(object({<br>      active_target = optional(string, "primary")<br>      secondary_target = object({<br>        type = string<br>        id   = string<br>      })<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier used in the generated name. | `string` | `"network"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_active_targets"></a> [active\_targets](#output\_active\_targets) | Effective active target type and ID keyed by stable logical route name. |
| <a name="output_failover_enabled"></a> [failover\_enabled](#output\_failover\_enabled) | Whether each managed route has a declarative secondary target. |
| <a name="output_name"></a> [name](#output\_name) | Resolved route manager name. |
| <a name="output_route_ids"></a> [route\_ids](#output\_route\_ids) | Managed AWS route IDs keyed by stable logical route name. |
| <a name="output_route_table_ids"></a> [route\_table\_ids](#output\_route\_table\_ids) | Route table IDs keyed by stable logical route name. |
<!-- END_TF_DOCS -->
