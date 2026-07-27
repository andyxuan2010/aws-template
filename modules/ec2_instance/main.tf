resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  iam_instance_profile        = var.iam_instance_profile_name
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip_address
  monitoring                  = var.monitoring
  disable_api_termination     = var.disable_api_termination
  ebs_optimized               = var.ebs_optimized
  user_data                   = var.user_data
  user_data_replace_on_change = var.user_data_replace_on_change
  tags                        = local.tags

  metadata_options {
    http_endpoint               = var.metadata_options.http_endpoint
    http_tokens                 = var.metadata_options.http_tokens
    http_put_response_hop_limit = var.metadata_options.http_put_response_hop_limit
    instance_metadata_tags      = var.metadata_options.instance_metadata_tags
  }

  root_block_device {
    volume_type           = var.root_block_device.volume_type
    volume_size           = var.root_block_device.volume_size
    iops                  = var.root_block_device.iops
    throughput            = var.root_block_device.throughput
    encrypted             = var.root_block_device.encrypted
    kms_key_id            = var.root_block_device.kms_key_id
    delete_on_termination = var.root_block_device.delete_on_termination
    tags                  = merge(local.tags, { Name = "${local.name}-root" })
  }

  lifecycle {
    precondition {
      condition     = var.environment != "prod" || var.disable_api_termination
      error_message = "Production instances must enable API termination protection."
    }

    precondition {
      condition     = var.metadata_options.http_tokens == "required"
      error_message = "IMDSv2 tokens are mandatory."
    }

    precondition {
      condition     = var.root_block_device.encrypted
      error_message = "The root EBS volume must be encrypted."
    }

    precondition {
      condition     = var.environment != "prod" || !var.associate_public_ip_address
      error_message = "Production instances cannot receive a public IP address."
    }
  }
}
