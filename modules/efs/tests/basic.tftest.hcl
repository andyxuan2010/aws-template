mock_provider "aws" {}

run "encrypted_multi_az_file_system" {
  command = plan

  variables {
    region_code        = "use1"
    subnet_ids         = { az_a = "subnet-0123456789abcdef0", az_b = "subnet-0123456789abcdef1" }
    security_group_ids = ["sg-0123456789abcdef0"]
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

  assert {
    condition     = aws_efs_file_system.this.encrypted
    error_message = "EFS storage must be encrypted at rest."
  }

  assert {
    condition     = aws_efs_backup_policy.this.backup_policy[0].status == "ENABLED"
    error_message = "EFS automatic backups must be enabled."
  }

  assert {
    condition     = length(aws_efs_mount_target.this) == 2 && aws_efs_mount_target.this["az_a"].subnet_id == "subnet-0123456789abcdef0"
    error_message = "Mount targets must be created in each supplied subnet."
  }

  assert {
    condition     = aws_efs_access_point.this["application"].root_directory[0].path == "/application"
    error_message = "The access point must use its requested root path."
  }
}
