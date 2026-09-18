# ECS service module

Creates a Fargate task definition and ECS service on an existing cluster.
Cluster governance, execution/task IAM roles, container images, log groups,
secrets, networking, and load balancer target groups remain explicit external
dependencies.

```hcl
module "api" {
  source = "../../modules/ecs_service"

  region_code       = "use1"
  cluster_arn       = aws_ecs_cluster.platform.arn
  execution_role_arn = module.execution_role.role_arn
  task_role_arn      = module.task_role.role_arn
  subnet_ids         = values(module.vpc.private_subnet_ids)
  security_group_ids = [module.api_sg.security_group_id]

  container_definitions_json = jsonencode([{
    name      = "api"
    image     = "${module.repository.repository_url}:v1.0.0"
    essential = true
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/api"
        awslogs-region        = "us-east-1"
        awslogs-stream-prefix = "service"
      }
    }
  }])
}
```

Tasks cannot receive public IPs, the deployment circuit breaker is mandatory,
and production requires at least two tasks. Container definitions must reference
Secrets Manager or Parameter Store rather than embedding plaintext secrets.
## Prerequisites and Dependencies

Configure the AWS provider and credentials in the calling root module. Pass
dependencies through typed inputs and module outputs; this child module does
not configure providers or a backend.

## Important Behavior and Secure Defaults

Review the module defaults, lifecycle implications, replacement behavior, and
AWS service costs before use. Production guardrails fail during planning when
an unsafe combination can be detected statically.

## Naming and Tagging

Generated names and effective tags follow the repository
[naming convention](../../docs/NAMING_CONVENTION.md) and
[tagging standard](../../docs/TAGGING_STANDARD.md). Stable map keys are
Terraform resource identity and should not be renamed casually.

## Testing

`powershell
terraform init -backend=false
terraform validate
terraform test
`

Tests use mocked providers and do not apply AWS resources.

## Known Limitations

The module owns only the resources documented below. Account-level policies,
cross-account trust, service quotas, and live integration verification remain
the responsibility of the calling composition.

## Terraform Reference

The content below is generated from module source. Do not edit it manually.

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
| [aws_ecs_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assign_public_ip"></a> [assign\_public\_ip](#input\_assign\_public\_ip) | Assign public IPs to tasks. | `bool` | `false` | no |
| <a name="input_cluster_arn"></a> [cluster\_arn](#input\_cluster\_arn) | ARN of an existing ECS cluster. | `string` | n/a | yes |
| <a name="input_container_definitions_json"></a> [container\_definitions\_json](#input\_container\_definitions\_json) | ECS container definitions JSON. Use Secrets Manager or Parameter Store references instead of plaintext secrets. | `string` | n/a | yes |
| <a name="input_cpu_architecture"></a> [cpu\_architecture](#input\_cpu\_architecture) | Task CPU architecture. | `string` | `"ARM64"` | no |
| <a name="input_deployment_maximum_percent"></a> [deployment\_maximum\_percent](#input\_deployment\_maximum\_percent) | Maximum running percentage during deployments. | `number` | `200` | no |
| <a name="input_deployment_minimum_healthy_percent"></a> [deployment\_minimum\_healthy\_percent](#input\_deployment\_minimum\_healthy\_percent) | Minimum healthy percentage during deployments. | `number` | `100` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | Desired running task count. | `number` | `1` | no |
| <a name="input_enable_deployment_circuit_breaker"></a> [enable\_deployment\_circuit\_breaker](#input\_enable\_deployment\_circuit\_breaker) | Stop failed deployments. | `bool` | `true` | no |
| <a name="input_enable_execute_command"></a> [enable\_execute\_command](#input\_enable\_execute\_command) | Enable ECS Exec. Disabled by default and should be governed and audited when enabled. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_ephemeral_storage_gib"></a> [ephemeral\_storage\_gib](#input\_ephemeral\_storage\_gib) | Fargate ephemeral storage in GiB. Null uses the service default. | `number` | `null` | no |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | Task execution role ARN. | `string` | n/a | yes |
| <a name="input_health_check_grace_period_seconds"></a> [health\_check\_grace\_period\_seconds](#input\_health\_check\_grace\_period\_seconds) | Load balancer health-check grace period. | `number` | `60` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_load_balancers"></a> [load\_balancers](#input\_load\_balancers) | ALB/NLB target-group attachments keyed by stable logical name. | <pre>map(object({<br>    target_group_arn = string<br>    container_name   = string<br>    container_port   = number<br>  }))</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Explicit ECS service and task-family name. When empty, the standard name is generated. | `string` | `""` | no |
| <a name="input_operating_system_family"></a> [operating\_system\_family](#input\_operating\_system\_family) | Task operating system family. | `string` | `"LINUX"` | no |
| <a name="input_platform_version"></a> [platform\_version](#input\_platform\_version) | Fargate platform version. | `string` | `"LATEST"` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short AWS region code. | `string` | n/a | yes |
| <a name="input_rollback_on_deployment_failure"></a> [rollback\_on\_deployment\_failure](#input\_rollback\_on\_deployment\_failure) | Roll back failed deployments. | `bool` | `true` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security groups attached to task network interfaces. | `set(string)` | n/a | yes |
| <a name="input_service_registry_arn"></a> [service\_registry\_arn](#input\_service\_registry\_arn) | Optional Cloud Map service registry ARN. | `string` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Private subnets for task network interfaces. | `set(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Service-specific tags. | `map(string)` | `{}` | no |
| <a name="input_task_cpu"></a> [task\_cpu](#input\_task\_cpu) | Task CPU units. | `number` | `256` | no |
| <a name="input_task_memory"></a> [task\_memory](#input\_task\_memory) | Task memory in MiB. | `number` | `512` | no |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | Application task role ARN. Keep separate from the execution role. | `string` | `null` | no |
| <a name="input_wait_for_steady_state"></a> [wait\_for\_steady\_state](#input\_wait\_for\_steady\_state) | Wait for the service to reach steady state. | `bool` | `true` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_id"></a> [service\_id](#output\_service\_id) | ECS service ID. |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | Resolved ECS service name. |
| <a name="output_task_definition_arn"></a> [task\_definition\_arn](#output\_task\_definition\_arn) | Task definition ARN including revision. |
| <a name="output_task_definition_family"></a> [task\_definition\_family](#output\_task\_definition\_family) | Task definition family. |
| <a name="output_task_definition_revision"></a> [task\_definition\_revision](#output\_task\_definition\_revision) | Task definition revision. |
<!-- END_TF_DOCS -->
