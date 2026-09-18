# Gateway Load Balancer module

Creates an AWS Gateway Load Balancer (GWLB) for FortiGate-VM inspection. The
module creates a GENEVE target group on port 6081, a GWLB listener, and IP
target registrations for FortiGate traffic interfaces. It does not create the
FortiGate instances, VPC, subnets, routes, Gateway Load Balancer endpoints,
endpoint services, or security groups.

GWLB is the appropriate choice for inline network appliance insertion. The
calling composition must configure route tables and GWLB endpoints so traffic
is actually steered through the inspection service.

## Minimum example

```hcl
module "fortigate_gwlb" {
  source = "../../modules/gateway_load_balancer"

  workload = "edge"
  region_code = "use1"
  vpc_id = "vpc-0123456789abcdef0"

  subnet_mappings = {
    az_a = {
      availability_zone = "us-east-1a"
      subnet_id          = "subnet-0123456789abcdef0"
    }
    az_b = {
      availability_zone = "us-east-1b"
      subnet_id          = "subnet-0123456789abcdef1"
    }
  }

  # Use the FortiGate traffic-interface IPs, not the management or heartbeat IPs.
  targets = {
    fortigate_a = { availability_zone = "us-east-1a", ip = "10.0.10.10" }
    fortigate_b = { availability_zone = "us-east-1b", ip = "10.0.20.10" }
  }
}
```

The FortiGate interface selected as a target must be configured for AWS GWLB
GENEVE traffic. FortiOS also needs a GENEVE interface and suitable health-check
response configuration; those commands are outside this module and can be
provided through the FortiGate module's bootstrap input.

## Health checks and HA

The default health check is TCP on port 443. HTTPS health checks are supported
when FortiOS is configured to respond to the selected path. Every enabled GWLB
Availability Zone must have at least one registered FortiGate target in that
zone. Cross-zone load balancing and deletion protection are enabled by default.

GWLB flow stickiness is disabled as a configurable override by default, which
retains AWS's default 5-tuple flow stickiness. `target_failover` defaults to
`no_rebalance` for both unhealthy and deregistered targets. Review these
settings with the FortiGate HA design before changing them.

## Dependencies and limitations

Configure the AWS provider and credentials in the root composition. Target IPs
must be private addresses in the VPC or an AWS-supported private range. AWS
Marketplace subscriptions, FortiGate licensing, GENEVE configuration, route
tables, GWLB endpoint services, GWLB endpoints, and security groups remain
caller responsibilities. Creating or changing a target's Availability Zone or
IP can deregister and re-register the target.

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
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deregistration_delay"></a> [deregistration\_delay](#input\_deregistration\_delay) | Seconds that the target group waits before deregistering a FortiGate target. | `number` | `300` | no |
| <a name="input_enable_cross_zone_load_balancing"></a> [enable\_cross\_zone\_load\_balancing](#input\_enable\_cross\_zone\_load\_balancing) | Enable cross-zone load balancing. Recommended when FortiGate targets span Availability Zones. | `bool` | `true` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | Protect the Gateway Load Balancer from API deletion. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | FortiGate health check. TCP/443 is the default; HTTPS/443 with path can be selected when FortiOS probe-response is configured. | <pre>object({<br>    enabled             = optional(bool, true)<br>    protocol            = optional(string, "TCP")<br>    port                = optional(number, 443)<br>    path                = optional(string, "/")<br>    matcher             = optional(string, "200-399")<br>    interval            = optional(number, 30)<br>    timeout             = optional(number, 5)<br>    healthy_threshold   = optional(number, 3)<br>    unhealthy_threshold = optional(number, 3)<br>  })</pre> | `{}` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags supplied by the root composition. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_name"></a> [name](#input\_name) | Explicit Gateway Load Balancer name. When empty, the standard name is generated. | `string` | `""` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short AWS region code, for example use1. | `string` | n/a | yes |
| <a name="input_stickiness"></a> [stickiness](#input\_stickiness) | Optional configurable GWLB flow stickiness. Disabled uses AWS's default 5-tuple flow stickiness. | <pre>object({<br>    enabled = optional(bool, false)<br>    type    = optional(string, "source_ip_dest_ip_proto")<br>  })</pre> | `{}` | no |
| <a name="input_subnet_mappings"></a> [subnet\_mappings](#input\_subnet\_mappings) | GWLB subnet mappings keyed by stable logical name. Use one subnet per Availability Zone; private IPv4 addresses are optional. | <pre>map(object({<br>    availability_zone    = string<br>    subnet_id            = string<br>    private_ipv4_address = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource-specific tags. | `map(string)` | `{}` | no |
| <a name="input_target_failover"></a> [target\_failover](#input\_target\_failover) | GWLB target failover behavior for existing flows. Both settings must match. | <pre>object({<br>    on_deregistration = optional(string, "no_rebalance")<br>    on_unhealthy      = optional(string, "no_rebalance")<br>  })</pre> | `{}` | no |
| <a name="input_target_group_name"></a> [target\_group\_name](#input\_target\_group\_name) | Optional GENEVE target group name. When empty, it is derived from the load balancer name. | `string` | `""` | no |
| <a name="input_targets"></a> [targets](#input\_targets) | FortiGate traffic-interface IP targets keyed by stable logical name. Targets use GENEVE port 6081 and should normally be the FortiGate interface IPs configured for GWLB traffic. | <pre>map(object({<br>    availability_zone = string<br>    ip                = string<br>  }))</pre> | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC containing the FortiGate target interfaces and Gateway Load Balancer. | `string` | n/a | yes |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"network"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_zones"></a> [availability\_zones](#output\_availability\_zones) | Availability Zones enabled on the Gateway Load Balancer. |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | Gateway Load Balancer DNS name. |
| <a name="output_listener_arn"></a> [listener\_arn](#output\_listener\_arn) | Gateway Load Balancer listener ARN. |
| <a name="output_load_balancer_arn"></a> [load\_balancer\_arn](#output\_load\_balancer\_arn) | Gateway Load Balancer ARN. |
| <a name="output_load_balancer_arn_suffix"></a> [load\_balancer\_arn\_suffix](#output\_load\_balancer\_arn\_suffix) | Gateway Load Balancer ARN suffix for CloudWatch metrics. |
| <a name="output_name"></a> [name](#output\_name) | Resolved Gateway Load Balancer name. |
| <a name="output_target_attachment_ids"></a> [target\_attachment\_ids](#output\_target\_attachment\_ids) | Target registration IDs keyed by the stable target input key. |
| <a name="output_target_group_arn"></a> [target\_group\_arn](#output\_target\_group\_arn) | GENEVE target group ARN. |
| <a name="output_target_group_arn_suffix"></a> [target\_group\_arn\_suffix](#output\_target\_group\_arn\_suffix) | GENEVE target group ARN suffix for CloudWatch metrics. |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | Route 53 canonical hosted zone ID. |
<!-- END_TF_DOCS -->
