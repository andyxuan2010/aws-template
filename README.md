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
| [`ec2_instance`](modules/ec2_instance) | Hardened virtual machine compute | `linuxvm`, `winvm` |
| [`application_load_balancer`](modules/application_load_balancer) | Layer 7 load balancing, listeners, and target groups | `applicationgateway` |
| [`rds`](modules/rds) | Encrypted managed relational databases | `sqldb`, `sqlmi` |
| [`lambda_function`](modules/lambda_function) | ZIP or container-based serverless functions | `functionapp` |
| [`secrets_manager`](modules/secrets_manager) | Secret metadata, replication, policies, and rotation | `keyvault` |
| [`ecr_repository`](modules/ecr_repository) | Scanned, immutable container image registry | `acr` |
| [`ecs_service`](modules/ecs_service) | Fargate task definition and service | `containerapp` |
| [`dynamodb_table`](modules/dynamodb_table) | Encrypted NoSQL table with recovery controls | `cosmosdb` |
| [`sqs_queue`](modules/sqs_queue) | Encrypted standard or FIFO message queue | `servicebus` |
| [`sns_topic`](modules/sns_topic) | Encrypted pub/sub topic and subscriptions | `eventhub`, `servicebus` |

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

After all checks pass on canonical `main`, GitHub Actions publishes a clean
snapshot to the configured staging repository. The staging publication uses a
repository-scoped deploy key and is not an AWS deployment.

## Standards

- [`docs/NAMING_CONVENTION.md`](docs/NAMING_CONVENTION.md)
- [`docs/TAGGING_STANDARD.md`](docs/TAGGING_STANDARD.md)
- [`docs/MODULES_INDEX.md`](docs/MODULES_INDEX.md)
- [`docs/TERRAFORM_MODULE_STANDARD.md`](docs/TERRAFORM_MODULE_STANDARD.md)

The engineering standard is authoritative when an Azure-aligned convention
conflicts with an AWS service constraint or a Terraform best practice.
