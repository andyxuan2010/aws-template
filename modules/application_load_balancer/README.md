# Application Load Balancer module

Creates a hardened Application Load Balancer, target groups, health checks, and
forwarding listeners. It is internal, deletion-protected, HTTP/2-enabled, and
drops invalid header fields by default.

Internet-facing listeners must use HTTPS. Production requires access logs and
deletion protection. Listener rules beyond the default forwarding action should
be composed separately when applications need host- or path-based routing.
Target-group names include a stable hash of the logical map key so AWS's
32-character limit cannot collapse distinct keys into the same name.

```hcl
module "alb" {
  source = "../../modules/application_load_balancer"

  region_code       = "use1"
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = values(module.vpc.private_subnet_ids)
  security_group_ids = [module.alb_sg.security_group_id]

  target_groups = {
    app = { port = 8080 }
  }

  listeners = {
    http = {
      port             = 80
      protocol         = "HTTP"
      target_group_key = "app"
    }
  }
}
```
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
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs"></a> [access\_logs](#input\_access\_logs) | Optional S3 access-log destination. | <pre>object({<br>    bucket = string<br>    prefix = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_drop_invalid_header_fields"></a> [drop\_invalid\_header\_fields](#input\_drop\_invalid\_header\_fields) | Drop HTTP headers with invalid fields. | `bool` | `true` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | Protect the ALB from API deletion. | `bool` | `true` | no |
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | Enable HTTP/2. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | Idle timeout in seconds. | `number` | `60` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | Create an internal ALB. Internet-facing load balancers require explicit opt-in. | `bool` | `true` | no |
| <a name="input_listeners"></a> [listeners](#input\_listeners) | Listeners keyed by stable logical name. HTTPS listeners require a certificate. | <pre>map(object({<br>    port                       = number<br>    protocol                   = string<br>    target_group_key           = string<br>    certificate_arn            = optional(string)<br>    ssl_policy                 = optional(string, "ELBSecurityPolicy-TLS13-1-2-2021-06")<br>    mutual_authentication_mode = optional(string, "off")<br>    trust_store_arn            = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Explicit ALB name. When empty, a 32-character-safe standard name is generated. | `string` | `""` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short AWS region code. | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security groups attached to the ALB. | `set(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs spanning at least two Availability Zones. | `set(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | ALB-specific tags. | `map(string)` | `{}` | no |
| <a name="input_target_groups"></a> [target\_groups](#input\_target\_groups) | Target groups keyed by stable logical name. | <pre>map(object({<br>    port                 = number<br>    protocol             = optional(string, "HTTP")<br>    protocol_version     = optional(string, "HTTP1")<br>    target_type          = optional(string, "instance")<br>    deregistration_delay = optional(number, 300)<br>    health_check = optional(object({<br>      enabled             = optional(bool, true)<br>      path                = optional(string, "/")<br>      port                = optional(string, "traffic-port")<br>      protocol            = optional(string, "HTTP")<br>      matcher             = optional(string, "200-399")<br>      interval            = optional(number, 30)<br>      timeout             = optional(number, 5)<br>      healthy_threshold   = optional(number, 3)<br>      unhealthy_threshold = optional(number, 3)<br>    }), {})<br>    tags = optional(map(string), {})<br>  }))</pre> | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC containing the target groups. | `string` | n/a | yes |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | ALB DNS name. |
| <a name="output_listener_arns"></a> [listener\_arns](#output\_listener\_arns) | Listener ARNs keyed by logical name. |
| <a name="output_load_balancer_arn"></a> [load\_balancer\_arn](#output\_load\_balancer\_arn) | ALB ARN. |
| <a name="output_load_balancer_arn_suffix"></a> [load\_balancer\_arn\_suffix](#output\_load\_balancer\_arn\_suffix) | ALB ARN suffix for CloudWatch metrics. |
| <a name="output_name"></a> [name](#output\_name) | Resolved ALB name. |
| <a name="output_target_group_arns"></a> [target\_group\_arns](#output\_target\_group\_arns) | Target group ARNs keyed by logical name. |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | Route 53 canonical hosted zone ID. |
<!-- END_TF_DOCS -->
