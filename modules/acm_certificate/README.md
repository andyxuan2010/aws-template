# AWS Certificate Manager Certificate

Requests an ACM public certificate and optionally creates Route 53 DNS validation records.

## Features

- DNS or email validation, SANs, supported RSA/ECDSA algorithms, and safe replacement.
- Optional Route 53 validation and validation wait.
- Certificate Transparency logging enabled by default.

## Resources Created

An ACM certificate, optional DNS records, and optional validation waiter.

## Prerequisites and Dependencies

DNS validation requires an existing Route 53 hosted zone. CloudFront certificates must be requested with an `us-east-1` provider supplied by the caller.

## Basic Usage

```hcl
module "certificate" {
  source         = "./modules/acm_certificate"
  domain_name    = "api.example.com"
  hosted_zone_id = module.dns.zone_id
}
```

## Important Behavior and Secure Defaults

Certificate replacement uses `create_before_destroy`; DNS validation and transparency logging are defaults.

## Naming and Tagging

The normalized domain becomes the Name tag.

## Testing

Run `terraform init -backend=false`, `terraform validate`, and `terraform test`.

## Known Limitations

Private CA issuance and imported certificates are outside this module.

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
| [aws_acm_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_route53_record.validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificate_transparency_logging_preference"></a> [certificate\_transparency\_logging\_preference](#input\_certificate\_transparency\_logging\_preference) | Certificate Transparency logging preference. | `string` | `"ENABLED"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Primary certificate DNS name. | `string` | n/a | yes |
| <a name="input_hosted_zone_id"></a> [hosted\_zone\_id](#input\_hosted\_zone\_id) | Route 53 zone ID used to create DNS validation records. | `string` | `null` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags. | `map(string)` | `{}` | no |
| <a name="input_key_algorithm"></a> [key\_algorithm](#input\_key\_algorithm) | Certificate key algorithm. | `string` | `"RSA_2048"` | no |
| <a name="input_subject_alternative_names"></a> [subject\_alternative\_names](#input\_subject\_alternative\_names) | Additional certificate DNS names. | `set(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Certificate-specific tags. | `map(string)` | `{}` | no |
| <a name="input_validation_method"></a> [validation\_method](#input\_validation\_method) | Certificate validation method. | `string` | `"DNS"` | no |
| <a name="input_validation_record_ttl"></a> [validation\_record\_ttl](#input\_validation\_record\_ttl) | DNS validation record TTL. | `number` | `60` | no |
| <a name="input_wait_for_validation"></a> [wait\_for\_validation](#input\_wait\_for\_validation) | Wait for ACM certificate validation. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate_arn"></a> [certificate\_arn](#output\_certificate\_arn) | Certificate ARN. |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | Normalized primary domain name. |
| <a name="output_domain_validation_options"></a> [domain\_validation\_options](#output\_domain\_validation\_options) | ACM domain validation options. |
| <a name="output_tags"></a> [tags](#output\_tags) | Effective certificate tags. |
| <a name="output_validation_record_fqdns"></a> [validation\_record\_fqdns](#output\_validation\_record\_fqdns) | Created DNS validation record FQDNs. |
<!-- END_TF_DOCS -->
