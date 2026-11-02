# GuardDuty module

Creates and enables a GuardDuty detector in the AWS provider's configured
Region. Protection plan features are opt-in and use AWS feature names, so a
root composition can enable only the data sources it needs.

See the [GuardDuty module architecture](docs/architecture.md) for regional
detector scope and caller-owned organization integrations.

## Features

- Provides GuardDuty detector and configurable protection features.
- Defaults include Detector enabled by default; additional protection plans opt-in;
  feature disable behavior documented.

## Resources Created

The primary managed resources include GuardDuty detector and configurable protection
features. Optional resources depend on module inputs; see the generated Terraform
Reference for the full inventory.

## Prerequisites and Dependencies

Configure AWS credentials and the provider Region in the calling root module.
The caller needs permission to manage GuardDuty detectors and detector
features. Some protection plans require supporting services, agents, or
service-linked roles.

## Provider Configuration

This module requires Terraform `>= 1.6.0` and `hashicorp/aws >= 5.0, < 7.0`. Configure
the provider, credentials, account, Region, and any aliases in the consuming root. This
child module contains no provider or backend configuration. See the generated Terraform
Reference for details.

## Basic Usage

```hcl
module "guardduty" {
  source = "../../modules/guardduty"

  region_code = "use1"
  environment = "prod"
  workload    = "platform"

  features = {
    S3_DATA_EVENTS = {}
    EKS_AUDIT_LOGS = {}
    RUNTIME_MONITORING = {
      additional_configuration = {
        EC2_AGENT_MANAGEMENT = "ENABLED"
      }
    }
  }
}
```

## Important Behavior and Secure Defaults

- The detector is enabled by default. Setting `enable = false` suspends
  monitoring while retaining findings. Destroying the detector disables
  GuardDuty in that Region and removes its existing findings.
- Protection plan features are not enabled unless present in `features`.
  Availability and prerequisites vary by Region and workload. GuardDuty pricing
  depends on analyzed service logs, events, workloads, and data; estimate and
  monitor usage before enabling additional plans.
- Feature resources are keyed by AWS feature name. Set a feature's status to
  `DISABLED` to turn it off. Removing a feature key from configuration removes
  its Terraform resource from state but does not disable the feature in AWS.
- `EKS_RUNTIME_MONITORING` and `RUNTIME_MONITORING` cannot be configured
  together. Runtime monitoring add-on management settings are passed through
  using `additional_configuration`.
- This module manages one detector in one account and Region. GuardDuty
  delegated administrators, organization membership, account auto-enable
  policies, finding destinations, and Security Hub integration belong in a
  separate organization or security composition.

## Naming and Tagging

The detector `Name` tag follows the repository naming convention. Effective
tags merge inherited tags, module tags, and the generated `Name` tag in that
order.

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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.38, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.38, < 7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_guardduty_detector.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_detector) | resource |
| [aws_guardduty_detector_feature.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_detector_feature) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable"></a> [enable](#input\_enable) | Enable monitoring and finding feedback. Set false to suspend while retaining existing findings. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_features"></a> [features](#input\_features) | Opt-in GuardDuty protection features keyed by AWS feature name. Features are not enabled unless listed. | <pre>map(object({<br>    status                   = optional(string, "ENABLED")<br>    additional_configuration = optional(map(string), {})<br>  }))</pre> | `{}` | no |
| <a name="input_finding_publishing_frequency"></a> [finding\_publishing\_frequency](#input\_finding\_publishing\_frequency) | Frequency at which subsequent occurrences of findings are published. | `string` | `"SIX_HOURS"` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags supplied by the root composition. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short region code, for example use1. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource-specific tags. | `map(string)` | `{}` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload or platform identifier used in the detector Name tag. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | AWS account ID that owns the detector. |
| <a name="output_detector_arn"></a> [detector\_arn](#output\_detector\_arn) | GuardDuty detector ARN. |
| <a name="output_detector_id"></a> [detector\_id](#output\_detector\_id) | GuardDuty detector ID for the provider's configured Region. |
| <a name="output_feature_statuses"></a> [feature\_statuses](#output\_feature\_statuses) | Configured feature statuses keyed by AWS feature name. |
<!-- END_TF_DOCS -->
