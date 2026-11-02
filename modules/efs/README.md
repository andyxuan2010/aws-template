# EFS module

Creates an encrypted Regional EFS file system, backup policy, mount targets,
and optional access points. VPC, client security groups, mount configuration,
and client IAM authorization remain caller-owned.

## Secure defaults

- Encrypts the file system at rest and enables AWS Backup integration.
- Creates mount targets only in supplied subnets and requires explicit security
  groups.
- Uses elastic throughput and transitions eligible files to IA after 30 days.
- Optional access points establish POSIX identities and root-directory
  permissions.

## Basic usage

```hcl
module "shared_files" {
  source = "../../modules/efs"

  workload          = "shared"
  region_code       = "use1"
  environment       = "prod"
  subnet_ids = {
    az_a = module.vpc.private_subnet_ids["private-a"]
    az_b = module.vpc.private_subnet_ids["private-b"]
  }
  security_group_ids = toset([module.efs_client_sg.security_group_id])
  access_points = {
    application = {
      path         = "/application"
      owner_uid    = 10001
      owner_gid    = 10001
      creation_uid = 10001
      creation_gid = 10001
    }
  }
}
```

Use one mount target subnet per Availability Zone. Permit NFS (TCP 2049) only
from approved client security groups. Clients should mount with TLS and use
access points where POSIX isolation is needed.

Common uses include shared application content, persistent files for multiple
EC2 or container clients, and POSIX-isolated application directories.

## Costs and operations

Storage class, throughput, backup storage, and data transfer affect cost. Mount
target and file-system deletion can interrupt active clients; back up data
before removal.

Configure AWS credentials and provider in the consuming root. Terraform
`>= 1.6.0`, AWS provider `>= 5.0, < 7.0`.

Generated names and tags follow the repository
[naming](../../docs/60-security-governance/naming-convention.md) and
[tagging](../../docs/60-security-governance/tagging-standard.md) standards.

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
| [aws_efs_access_point.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point) | resource |
| [aws_efs_backup_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_backup_policy) | resource |
| [aws_efs_file_system.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_points"></a> [access\_points](#input\_access\_points) | Optional access points keyed by stable logical name. | <pre>map(object({<br>    path          = string<br>    owner_uid     = number<br>    owner_gid     = number<br>    creation_uid  = number<br>    creation_gid  = number<br>    creation_mode = optional(string, "0750")<br>  }))</pre> | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | Optional customer-managed KMS key ID or ARN. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | EFS file system name; generated when empty. | `string` | `""` | no |
| <a name="input_provisioned_throughput_in_mibps"></a> [provisioned\_throughput\_in\_mibps](#input\_provisioned\_throughput\_in\_mibps) | Provisioned throughput when throughput\_mode is provisioned. | `number` | `null` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short AWS Region code. | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security groups allowing NFS only from approved clients. | `set(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Mount target subnet IDs keyed by stable AZ label; use one subnet per AZ. | `map(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource-specific tags. | `map(string)` | `{}` | no |
| <a name="input_throughput_mode"></a> [throughput\_mode](#input\_throughput\_mode) | EFS throughput mode. | `string` | `"elastic"` | no |
| <a name="input_transition_to_ia"></a> [transition\_to\_ia](#input\_transition\_to\_ia) | Optional lifecycle transition to IA, such as AFTER\_30\_DAYS. | `string` | `"AFTER_30_DAYS"` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_point_ids"></a> [access\_point\_ids](#output\_access\_point\_ids) | Access point IDs keyed by logical name. |
| <a name="output_file_system_arn"></a> [file\_system\_arn](#output\_file\_system\_arn) | EFS file system ARN. |
| <a name="output_file_system_id"></a> [file\_system\_id](#output\_file\_system\_id) | EFS file system ID. |
| <a name="output_mount_target_ids"></a> [mount\_target\_ids](#output\_mount\_target\_ids) | Mount target IDs keyed by subnet label. |
<!-- END_TF_DOCS -->
