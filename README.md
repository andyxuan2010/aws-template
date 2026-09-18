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
| [`fortigate`](modules/fortigate) | FortiGate-VM AMI, licensing, bootstrap, multi-ENI, and active-passive HA | `fortigate` |
| [`gateway_load_balancer`](modules/gateway_load_balancer) | Gateway Load Balancer, GENEVE target group, listener, and FortiGate IP targets | `gateway_load_balancer` |
| [`route_manager`](modules/route_manager) | VPC route management for FortiGate ENIs or GWLB endpoints with declarative failover switching | `route_manager` |
| [`application_load_balancer`](modules/application_load_balancer) | Layer 7 load balancing, listeners, and target groups | `applicationgateway` |
| [`rds`](modules/rds) | Encrypted managed relational databases | `sqldb`, `sqlmi` |
| [`lambda_function`](modules/lambda_function) | ZIP or container-based serverless functions | `functionapp` |
| [`secrets_manager`](modules/secrets_manager) | Secret metadata, replication, policies, and rotation | `keyvault` |
| [`ecr_repository`](modules/ecr_repository) | Scanned, immutable container image registry | `acr` |
| [`ecs_service`](modules/ecs_service) | Fargate task definition and service | `containerapp` |
| [`dynamodb_table`](modules/dynamodb_table) | Encrypted NoSQL table with recovery controls | `cosmosdb` |
| [`sqs_queue`](modules/sqs_queue) | Encrypted standard or FIFO message queue | `servicebus` |
| [`sns_topic`](modules/sns_topic) | Encrypted pub/sub topic and subscriptions | `eventhub`, `servicebus` |
| [`route53`](modules/route53) | Public and private DNS zones and records | `dnszone`, `privatednszone` |
| [`acm_certificate`](modules/acm_certificate) | Managed TLS certificates and DNS validation | App Service or Key Vault certificates |
| [`cloudwatch_monitoring`](modules/cloudwatch_monitoring) | Logs, metric alarms, and dashboards | Azure Monitor, Log Analytics |
| [`waf_web_acl`](modules/waf_web_acl) | Managed web firewall and rate controls | Web Application Firewall policy |
| [`api_gateway`](modules/api_gateway) | HTTP and WebSocket APIs, routes, integrations, and stages | API Management |
| [`eventbridge`](modules/eventbridge) | Event buses, rules, targets, and archives | Event Grid |
| [`step_functions`](modules/step_functions) | Standard and Express workflow orchestration | Logic Apps |
| [`aws_backup`](modules/aws_backup) | Backup vaults, plans, selections, and Vault Lock | Recovery Services vault |

Each module uses the same core file layout: `terraform.tf`, `variables.tf`,
`locals.tf`, `main.tf`, `outputs.tf`, `README.md`, and `tests/`.

## Quick start

See [`examples/foundation`](examples/foundation) for a composition that wires all
five modules together.

```powershell
terraform fmt -check -recursive
./scripts/Test-TerraformModules.ps1
./scripts/Update-ModuleDocs.ps1
```

Terraform `>= 1.6` and AWS provider `>= 5.0, < 7.0` are required. Modules do not
configure providers; root configurations own AWS authentication and provider
default tags.

The GitHub Actions workflow formats, lints, scans, validates, runs mocked
module tests, and plans the foundation example without AWS credentials, AWS
API access, or a remote backend. On successful `main`, `dev`, or `sbx` pushes,
it can publish a clean snapshot to a separate GitHub stage repository when the
`STAGE_REPOSITORY` repository variable and `STAGE_REPO_TOKEN` secret are
configured. It can also synchronize Git history to an Azure DevOps development
repository when `ADO_DEV_REPOSITORY` and `ADO_DEV_REPO_PAT` are configured.
The stage and ADO jobs never apply or deploy AWS resources.

The separate [`Publish documentation portal`](.github/workflows/pages.yml)
workflow publishes the Markdown library through GitHub Pages after documentation
changes on `main`. It generates the document manifest during the workflow and
does not require AWS credentials or AWS access. The publish job is gated to
the `main` branch for any repository. When the repository is private, it still
generates the portal manifest but skips the GitHub Pages configuration, upload,
and deployment steps because GitHub Pages requires a public repository here.

Before the first publication, enable GitHub Pages for the repository in
**Settings → Pages → Build and deployment → Source → GitHub Actions**. The
standard `GITHUB_TOKEN` used by this workflow can deploy an already-enabled
Pages site; repository administration is intentionally left as a one-time
maintainer setting.

## Validation coverage

The repository validation harness runs backend-free `terraform init`,
`terraform validate`, and mocked `terraform test` for every module. The
FortiGate path has dedicated coverage for:

- `fortigate`: secure single-node defaults, active-passive bootstrap, and
  rejection of unsafe production public exposure.
- `gateway_load_balancer`: FortiGate GENEVE defaults, HTTPS health checks, and
  rejection of incomplete or unsafe production target configuration.
- `route_manager`: FortiGate ENI routes, declarative primary/secondary
  failover, and GWLB endpoint routes.

Run the complete local gate from the repository root:

```powershell
terraform fmt -check -recursive
tflint --init
tflint --recursive --format compact
./scripts/Test-TerraformModules.ps1
./scripts/Update-ModuleDocs.ps1
```

The foundation example can be checked without AWS access using backend-free
initialization, validation, and an offline plan. See
[`examples/foundation`](examples/foundation) for the required placeholder
inputs.

The current repository gate has passed for all 25 modules. The FortiGate
modules passed 9 focused mocked tests in total, the foundation offline plan
completed successfully, and the local high/critical Trivy misconfiguration and
secret scan reported no findings.

## Standards

- [`docs/NAMING_CONVENTION.md`](docs/NAMING_CONVENTION.md)
- [`docs/TAGGING_STANDARD.md`](docs/TAGGING_STANDARD.md)
- [`docs/MODULES_INDEX.md`](docs/MODULES_INDEX.md)
- [`docs/GITHUB_ACTIONS_PIPELINE.md`](docs/GITHUB_ACTIONS_PIPELINE.md)
- [`docs/TERRAFORM_MODULE_STANDARD.md`](docs/TERRAFORM_MODULE_STANDARD.md)

The engineering standard is authoritative when an Azure-aligned convention
conflicts with an AWS service constraint or a Terraform best practice.
