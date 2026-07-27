# CCOE AWS Terraform Template

Reusable AWS Terraform modules for composing secure landing zones and workload
environments. This repository mirrors the conventions of the sibling
`azure-template` repository where the concepts translate to AWS.

## Modules

| Module | Purpose | Azure-aligned counterpart |
| --- | --- | --- |
| [`vpc`](modules/vpc) | VPC, subnets, internet gateway, route tables, and optional NAT gateways | `vnet`, `subnet`, `route_table` |
| [`security_group`](modules/security_group) | Stateful ingress and egress controls | `nsg` |
| [`s3_bucket`](modules/s3_bucket) | Secure, encrypted, versioned object storage | `storageaccount` |
| [`iam_role`](modules/iam_role) | IAM roles, policies, and optional instance profiles | `managedidentity`, `roleassignments` |
| [`kms_key`](modules/kms_key) | Customer-managed encryption keys, aliases, and grants | `keyvault` |

Each module uses the same core file layout: `terraform.tf`, `variables.tf`,
`locals.tf`, `main.tf`, `outputs.tf`, `README.md`, and `tests/`.

## Quick start

See [`examples/foundation`](examples/foundation) for a composition that wires all
five modules together.

```powershell
terraform fmt -check -recursive
./scripts/Test-TerraformModules.ps1
```

Terraform `>= 1.6` and AWS provider `>= 5.0, < 7.0` are required. Modules do not
configure providers; root configurations own AWS authentication and provider
default tags.

The GitHub Actions workflow is validation-only. It formats, lints, scans,
validates, and runs mocked tests without AWS credentials, a remote backend,
`terraform plan`, or deployment.

## Standards

- [`docs/NAMING_CONVENTION.md`](docs/NAMING_CONVENTION.md)
- [`docs/TAGGING_STANDARD.md`](docs/TAGGING_STANDARD.md)
- [`docs/MODULES_INDEX.md`](docs/MODULES_INDEX.md)
- [`docs/TERRAFORM_MODULE_STANDARD.md`](docs/TERRAFORM_MODULE_STANDARD.md)

The engineering standard is authoritative when an Azure-aligned convention
conflicts with an AWS service constraint or a Terraform best practice.
