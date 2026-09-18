mock_provider "aws" {}

run "secure_fargate_defaults" {
  command = plan

  variables {
    region_code        = "use1"
    cluster_arn        = "arn:aws:ecs:us-east-1:123456789012:cluster/platform"
    execution_role_arn = "arn:aws:iam::123456789012:role/ecs-execution"
    subnet_ids         = ["subnet-0123456789abcdef0"]
    security_group_ids = ["sg-0123456789abcdef0"]
    container_definitions_json = jsonencode([{
      name      = "api"
      image     = "123456789012.dkr.ecr.us-east-1.amazonaws.com/api:v1"
      essential = true
    }])
  }

  assert {
    condition     = aws_ecs_task_definition.this.network_mode == "awsvpc"
    error_message = "Fargate tasks must use awsvpc networking."
  }

  assert {
    condition     = !aws_ecs_service.this.network_configuration[0].assign_public_ip
    error_message = "Tasks must not receive public IPs."
  }
}

run "reject_single_task_production_service" {
  command = plan

  variables {
    region_code        = "use1"
    environment        = "prod"
    cluster_arn        = "arn:aws:ecs:us-east-1:123456789012:cluster/platform"
    execution_role_arn = "arn:aws:iam::123456789012:role/ecs-execution"
    subnet_ids         = ["subnet-0123456789abcdef0"]
    security_group_ids = ["sg-0123456789abcdef0"]
    desired_count      = 1
    container_definitions_json = jsonencode([{
      name      = "api"
      image     = "123456789012.dkr.ecr.us-east-1.amazonaws.com/api:v1"
      essential = true
    }])
  }

  expect_failures = [aws_ecs_service.this]
}
