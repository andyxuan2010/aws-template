mock_provider "aws" {}

run "secure_database_defaults" {
  command = plan

  variables {
    engine                 = "postgres"
    engine_version         = "16.4"
    instance_class         = "db.t4g.small"
    master_username        = "platform_admin"
    region_code            = "use1"
    subnet_ids             = ["subnet-0123456789abcdef0", "subnet-1123456789abcdef0"]
    vpc_security_group_ids = ["sg-0123456789abcdef0"]
  }

  assert {
    condition     = aws_db_instance.this.storage_encrypted
    error_message = "RDS storage must be encrypted."
  }

  assert {
    condition     = aws_db_instance.this.manage_master_user_password
    error_message = "RDS must manage the master password."
  }

  assert {
    condition     = !aws_db_instance.this.publicly_accessible
    error_message = "RDS must not be publicly accessible."
  }
}

run "reject_public_database" {
  command = plan

  variables {
    engine                 = "postgres"
    engine_version         = "16.4"
    instance_class         = "db.t4g.small"
    master_username        = "platform_admin"
    region_code            = "use1"
    subnet_ids             = ["subnet-0123456789abcdef0", "subnet-1123456789abcdef0"]
    vpc_security_group_ids = ["sg-0123456789abcdef0"]
    publicly_accessible    = true
  }

  expect_failures = [aws_db_instance.this]
}
