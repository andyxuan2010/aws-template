# Auto Scaling module

Creates an EC2 launch template and Auto Scaling group. AMI maintenance,
instance-profile IAM permissions, security-group rules, and target groups remain
caller-owned.

## Secure defaults

- Requires at least two private subnets and explicit security groups.
- Requires IMDSv2, detailed monitoring, encrypted root EBS, and EBS deletion with
  the instance.
- Propagates normalized tags to instances and volumes; public IP assignment is
  not enabled by the launch template.
- Capacity relationships and ELB health-check requirements are checked during
  planning.

## Basic usage

```hcl
module "workers" {
  source = "../../modules/autoscaling"

  workload           = "api"
  region_code        = "use1"
  environment        = "prod"
  image_id           = "ami-0123456789abcdef0"
  instance_type      = "m7i.large"
  instance_profile_arn = module.instance_role.instance_profile_arn
  subnet_ids         = toset(values(module.vpc.private_subnet_ids))
  security_group_ids = toset([module.worker_sg.security_group_id])
  min_size           = 2
  desired_capacity   = 2
  max_size           = 6
}
```

Keep bootstrap data free of secrets. Instance profile roles and target groups
are caller-managed. The launch template's `$Latest` version is used by the ASG;
AMI changes can roll instances and should be reviewed in the plan.

Common uses include stateless application workers, queue consumers, and
self-managed services that need EC2 instance refresh or target-group health
checks.

## Costs and operations

EC2, EBS, detailed monitoring, and optional load balancing incur service costs.
Use a maintenance strategy such as instance refresh in the caller's rollout
process when changing launch-template settings.

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
| [aws_autoscaling_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_launch_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Initial desired group capacity. | `number` | `2` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_health_check_grace_period"></a> [health\_check\_grace\_period](#input\_health\_check\_grace\_period) | Health check grace period in seconds. | `number` | `300` | no |
| <a name="input_health_check_type"></a> [health\_check\_type](#input\_health\_check\_type) | ASG health check type. | `string` | `"EC2"` | no |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | Approved AMI ID. | `string` | n/a | yes |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_instance_profile_arn"></a> [instance\_profile\_arn](#input\_instance\_profile\_arn) | Caller-managed instance profile ARN. | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | EC2 instance type. | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | Optional customer-managed KMS key ARN for root EBS encryption. | `string` | `null` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Maximum group capacity. | `number` | `4` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum group capacity. | `number` | `2` | no |
| <a name="input_name"></a> [name](#input\_name) | Explicit Auto Scaling group name; generated when empty. | `string` | `""` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short AWS Region code. | `string` | n/a | yes |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | Encrypted root volume size in GiB. | `number` | `30` | no |
| <a name="input_root_volume_type"></a> [root\_volume\_type](#input\_root\_volume\_type) | Root EBS volume type. | `string` | `"gp3"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security groups to attach to instances. | `set(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Private subnet IDs spanning the desired Availability Zones. | `set(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource-specific tags. | `map(string)` | `{}` | no |
| <a name="input_target_group_arns"></a> [target\_group\_arns](#input\_target\_group\_arns) | Optional load balancer target groups. | `set(string)` | `[]` | no |
| <a name="input_user_data_base64"></a> [user\_data\_base64](#input\_user\_data\_base64) | Optional base64-encoded bootstrap script. Do not include secrets. | `string` | `null` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_autoscaling_group_arn"></a> [autoscaling\_group\_arn](#output\_autoscaling\_group\_arn) | Auto Scaling group ARN. |
| <a name="output_autoscaling_group_name"></a> [autoscaling\_group\_name](#output\_autoscaling\_group\_name) | Auto Scaling group name. |
| <a name="output_launch_template_id"></a> [launch\_template\_id](#output\_launch\_template\_id) | Launch template ID. |
| <a name="output_launch_template_latest_version"></a> [launch\_template\_latest\_version](#output\_launch\_template\_latest\_version) | Latest launch template version. |
<!-- END_TF_DOCS -->
