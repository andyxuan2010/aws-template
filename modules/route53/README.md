# Amazon Route 53

Creates one public or private Route 53 hosted zone and a stable map of DNS records.

## Features

- Public or VPC-associated private zones.
- Standard, alias, health-checked, and weighted records.
- Destructive zone cleanup disabled by default.

## Resources Created

- One hosted zone and zero or more records.

## Prerequisites and Dependencies

Private zones require existing VPC IDs. Alias targets must already exist.

## Basic Usage

```hcl
module "dns" {
  source    = "./modules/route53"
  zone_name = "example.com"
  records = { www = { name = "www", type = "A", records = ["192.0.2.10"] } }
}
```

## Important Behavior and Secure Defaults

`force_destroy` is false. Record map keys are Terraform identity and should remain stable.

## Naming and Tagging

The normalized zone name becomes the Name tag. Caller tags follow the repository tagging standard.

## Testing

Run `terraform init -backend=false`, `terraform validate`, and `terraform test`.

## Known Limitations

This module does not register domains or create DNSSEC signing keys.

## Terraform Reference

Generated from module source; do not edit manually.

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
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_comment"></a> [comment](#input\_comment) | Hosted-zone comment. | `string` | `"Managed by Terraform"` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Delete non-default records with the zone. | `bool` | `false` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags. | `map(string)` | `{}` | no |
| <a name="input_private_zone"></a> [private\_zone](#input\_private\_zone) | Create a private hosted zone. | `bool` | `false` | no |
| <a name="input_records"></a> [records](#input\_records) | DNS records keyed by stable logical name. | <pre>map(object({<br>    name            = string<br>    type            = string<br>    ttl             = optional(number, 300)<br>    records         = optional(list(string), [])<br>    allow_overwrite = optional(bool, false)<br>    set_identifier  = optional(string)<br>    health_check_id = optional(string)<br>    alias = optional(object({<br>      name                   = string,<br>      zone_id                = string,<br>      evaluate_target_health = optional(bool, false)<br>    }))<br>    weighted_routing_policy = optional(object({<br>      weight = number<br>    }))<br><br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Hosted-zone-specific tags. | `map(string)` | `{}` | no |
| <a name="input_vpc_associations"></a> [vpc\_associations](#input\_vpc\_associations) | VPC associations keyed by stable logical name. At least one is required for private zones. | <pre>map(object({<br>    vpc_id     = string,<br>    vpc_region = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_zone_name"></a> [zone\_name](#input\_zone\_name) | DNS name of the hosted zone. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | Authoritative name servers for a public zone. |
| <a name="output_record_fqdns"></a> [record\_fqdns](#output\_record\_fqdns) | Record FQDNs keyed by input key. |
| <a name="output_tags"></a> [tags](#output\_tags) | Effective hosted-zone tags. |
| <a name="output_zone_arn"></a> [zone\_arn](#output\_zone\_arn) | Hosted zone ARN. |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | Hosted zone ID. |
<!-- END_TF_DOCS -->
