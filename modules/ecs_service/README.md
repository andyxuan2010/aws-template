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
