resource "aws_efs_file_system" "this" {
  creation_token                  = local.name
  encrypted                       = true
  kms_key_id                      = var.kms_key_id
  throughput_mode                 = var.throughput_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  tags                            = local.tags

  lifecycle_policy {
    transition_to_ia = var.transition_to_ia

  }
  lifecycle {
    precondition {
      condition     = (var.throughput_mode == "provisioned") == (var.provisioned_throughput_in_mibps != null)
      error_message = "Set provisioned_throughput_in_mibps only when throughput_mode is provisioned."

    }

  }
}

resource "aws_efs_backup_policy" "this" {
  file_system_id = aws_efs_file_system.this.id
  backup_policy {
    status = "ENABLED"

  }
}

resource "aws_efs_mount_target" "this" {
  for_each        = var.subnet_ids
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value
  security_groups = var.security_group_ids
}

resource "aws_efs_access_point" "this" {
  for_each       = var.access_points
  file_system_id = aws_efs_file_system.this.id
  tags           = merge(local.tags, { Name = "${local.name}-${each.key}" })
  posix_user {
    uid = each.value.owner_uid
    gid = each.value.owner_gid

  }
  root_directory {
    path = each.value.path
    creation_info {
      owner_uid   = each.value.creation_uid
      owner_gid   = each.value.creation_gid
      permissions = each.value.creation_mode

    }

  }
}
