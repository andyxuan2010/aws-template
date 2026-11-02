resource "aws_launch_template" "this" {
  name_prefix            = "${local.name}-"
  image_id               = var.image_id
  instance_type          = var.instance_type
  user_data              = var.user_data_base64
  vpc_security_group_ids = var.security_group_ids

  iam_instance_profile {
    arn = var.instance_profile_arn

  }
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "disabled"

  }
  monitoring {
    enabled = true

  }
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      encrypted             = true
      kms_key_id            = var.kms_key_arn
      volume_size           = var.root_volume_size
      volume_type           = var.root_volume_type
      delete_on_termination = true

    }

  }
  tag_specifications {
    resource_type = "instance"
    tags          = local.tags

  }
  tag_specifications {
    resource_type = "volume"
    tags          = local.tags

  }
  tags = local.tags
}

resource "aws_autoscaling_group" "this" {
  name                      = local.name
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  vpc_zone_identifier       = var.subnet_ids
  target_group_arns         = var.target_group_arns
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  default_instance_warmup   = 300
  capacity_rebalance        = true
  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"

  }
  dynamic "tag" {
    for_each = local.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true

    }

  }
  lifecycle {
    precondition {
      condition     = var.min_size <= var.desired_capacity && var.desired_capacity <= var.max_size
      error_message = "Capacity must satisfy min_size <= desired_capacity <= max_size."

    }
    precondition {
      condition     = var.health_check_type != "ELB" || length(var.target_group_arns) > 0
      error_message = "ELB health checks require at least one target group."

    }
    precondition {
      condition     = var.environment != "prod" || var.min_size >= 2
      error_message = "Production Auto Scaling groups require a minimum capacity of at least two instances."
    }

  }
}
