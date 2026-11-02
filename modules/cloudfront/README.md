# CloudFront module

Creates a CloudFront distribution and private Origin Access Controls for S3
origins. Origin buckets, bucket policies, custom-domain DNS records, ACM
certificates, and WAF policies remain caller-owned.

## Secure defaults

- Redirects viewers to HTTPS and supports HTTP/2 and HTTP/3.
- Uses SigV4 Origin Access Control for S3 origins.
- Uses HTTPS-only custom origins by default and TLS 1.2 to origins.
- Requires a us-east-1 ACM certificate when alternate domain names are used.

## Basic usage

```hcl
module "cdn" {
  source = "../../modules/cloudfront"

  name             = "web-prod"
  origins = {
    assets = {
      domain_name = module.assets_bucket.bucket_regional_domain_name
      s3          = true
    }
  }
  default_origin_id = "assets"
  # AWS managed CachingOptimized cache policy.
  cache_policy_id   = "658327ea-f89d-4fab-a63d-7e88639e58f6"
}
```

The S3 bucket policy must grant `cloudfront.amazonaws.com` access scoped to the
created distribution ARN. OAC creation alone does not change bucket policy.
Custom origins must support HTTPS. Distribution changes may take about 15
minutes to deploy. ACM certificates for aliases must be in `us-east-1`.

Common uses include globally serving private S3 static assets and caching
HTTPS content from an existing API or web origin.

## Costs and operations

Requests, data transfer, invalidations, and optional WAF rules are billed
separately. Review cache policies and price class before deployment.

Configure AWS credentials and provider in the consuming root. Terraform
`>= 1.6.0`, AWS provider `>= 5.0, < 7.0`.

The explicit distribution name is also used for tags and OAC names. Follow the
repository [tagging standard](../../docs/60-security-governance/tagging-standard.md).

## Terraform Reference

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
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_control.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | ACM certificate ARN in us-east-1 for aliases. | `string` | `null` | no |
| <a name="input_aliases"></a> [aliases](#input\_aliases) | Optional alternate domain names. | `set(string)` | `[]` | no |
| <a name="input_cache_policy_id"></a> [cache\_policy\_id](#input\_cache\_policy\_id) | AWS or customer-managed CloudFront cache policy ID. | `string` | n/a | yes |
| <a name="input_default_origin_id"></a> [default\_origin\_id](#input\_default\_origin\_id) | Key of the origin used by the default behavior. | `string` | n/a | yes |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | Optional root object, such as index.html. | `string` | `null` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags. | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Distribution label and generated comment. | `string` | n/a | yes |
| <a name="input_origins"></a> [origins](#input\_origins) | Origin definitions keyed by stable logical ID. S3 origins get a private OAC; caller owns the bucket policy. | <pre>map(object({<br>    domain_name            = string<br>    s3                     = optional(bool, false)<br>    origin_path            = optional(string)<br>    origin_protocol_policy = optional(string, "https-only")<br>    http_port              = optional(number, 80)<br>    https_port             = optional(number, 443)<br>  }))</pre> | n/a | yes |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | CloudFront price class. | `string` | `"PriceClass_100"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource-specific tags. | `map(string)` | `{}` | no |
| <a name="input_web_acl_id"></a> [web\_acl\_id](#input\_web\_acl\_id) | Optional AWS WAFv2 web ACL ARN in the CloudFront scope. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_distribution_arn"></a> [distribution\_arn](#output\_distribution\_arn) | CloudFront distribution ARN. |
| <a name="output_distribution_id"></a> [distribution\_id](#output\_distribution\_id) | CloudFront distribution ID. |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | CloudFront distribution domain name. |
| <a name="output_origin_access_control_ids"></a> [origin\_access\_control\_ids](#output\_origin\_access\_control\_ids) | OAC IDs keyed by S3 origin key. |
<!-- END_TF_DOCS -->
