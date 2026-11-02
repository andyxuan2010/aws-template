mock_provider "aws" {}

run "secure_multi_az_defaults" {
  command = plan

  variables {
    region_code          = "use1"
    image_id             = "ami-0123456789abcdef0"
    instance_type        = "m7i.large"
    instance_profile_arn = "arn:aws:iam::111122223333:instance-profile/app"
    subnet_ids           = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
    security_group_ids   = ["sg-0123456789abcdef0"]
  }

  assert {
    condition     = aws_launch_template.this.metadata_options[0].http_tokens == "required"
    error_message = "Launch templates must require IMDSv2."
  }

  assert {
    condition     = aws_launch_template.this.monitoring[0].enabled
    error_message = "Detailed instance monitoring must be enabled."
  }

  assert {
    condition     = aws_autoscaling_group.this.min_size == 2 && aws_autoscaling_group.this.desired_capacity == 2 && aws_autoscaling_group.this.max_size == 4
    error_message = "The default Auto Scaling capacity must remain resilient and bounded."
  }
}

run "rejects_single_instance_production_capacity" {
  command = plan

  variables {
    region_code          = "use1"
    image_id             = "ami-0123456789abcdef0"
    instance_type        = "m7i.large"
    instance_profile_arn = "arn:aws:iam::111122223333:instance-profile/app"
    subnet_ids           = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
    security_group_ids   = ["sg-0123456789abcdef0"]
    environment          = "prod"
    min_size             = 1
    desired_capacity     = 1
    max_size             = 1
  }

  expect_failures = [aws_autoscaling_group.this]
}
