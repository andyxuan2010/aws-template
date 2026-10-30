# Security Hub CSPM module

Enables AWS Security Hub CSPM in the provider's account and Region, subscribes
to explicitly selected standards, and optionally creates a regional finding
aggregator. AWS Organizations administration and central configuration remain
outside this module.

## Secure defaults

- Does not implicitly enable default standards; subscribe only to the supplied
  standards ARNs.
- Automatically enables new controls for subscribed standards.
- Leaves organization-restricted finding consolidation settings to the
  designated Security Hub administrator.
- Optional finding aggregation is intended for one designated home Region.

## Basic usage

```hcl
module "security_hub" {
  source = "../../modules/security_hub_cspm"

  standards_arns = toset([
    "arn:aws:securityhub:us-east-1::standards/aws-foundational-security-best-practices/v/1.0.0"
  ])
  aggregation_linking_mode = "ALL_REGIONS"
}
```

Deploy the module in each in-scope account and Region. Configure the finding
aggregator only in the chosen home Region. AWS Config must be enabled and
recording the resources required by selected controls. Organization-wide
rollout, delegated administration, and central configuration need separate
Organizations-aware governance.

Common uses include enabling a baseline standard in an individual workload
account and aggregating findings across Regions for a standalone account.

## Costs and operations

Security Hub CSPM charges by enabled checks and ingested findings. Review
standards and control coverage before broad multi-account rollout. Destroying
the account resource disables Security Hub CSPM in that Region.

Configure AWS credentials and provider in the consuming root. Terraform
`>= 1.6.0`, AWS provider `>= 5.0, < 7.0`.

This module has no generated name or resource tags because Security Hub
account enablement and standards subscriptions are account-scoped service
settings.

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
| [aws_securityhub_account.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_account) | resource |
| [aws_securityhub_finding_aggregator.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_finding_aggregator) | resource |
| [aws_securityhub_standards_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_standards_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aggregation_linking_mode"></a> [aggregation\_linking\_mode](#input\_aggregation\_linking\_mode) | Optional finding aggregator mode; set only in the designated home Region. | `string` | `null` | no |
| <a name="input_auto_enable_controls"></a> [auto\_enable\_controls](#input\_auto\_enable\_controls) | Automatically enable new controls in subscribed standards. | `bool` | `true` | no |
| <a name="input_specified_regions"></a> [specified\_regions](#input\_specified\_regions) | Regions included by a SPECIFIED\_REGIONS finding aggregator. | `set(string)` | `[]` | no |
| <a name="input_standards_arns"></a> [standards\_arns](#input\_standards\_arns) | Explicit regional Security Hub standard ARNs to subscribe after CSPM is enabled. | `set(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | AWS account ID with Security Hub CSPM enabled. |
| <a name="output_finding_aggregator_arn"></a> [finding\_aggregator\_arn](#output\_finding\_aggregator\_arn) | Finding aggregator ARN when aggregation is enabled. |
| <a name="output_hub_arn"></a> [hub\_arn](#output\_hub\_arn) | Security Hub CSPM hub ARN. |
| <a name="output_standards_subscription_arns"></a> [standards\_subscription\_arns](#output\_standards\_subscription\_arns) | Standards subscription ARNs keyed by standards ARN. |
<!-- END_TF_DOCS -->
