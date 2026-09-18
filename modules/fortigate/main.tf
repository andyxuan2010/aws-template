# Copyright (c) CCOE-Azure.
# SPDX-License-Identifier: Proprietary
#
# Module: fortigate
# Description: Deploys FortiGate-VM on AWS with explicit AMI, licensing,
#              bootstrap, multi-ENI, and active-passive HA configuration.

resource "aws_network_interface" "additional" {
  for_each = local.additional_node_interfaces

  subnet_id         = each.value.subnet_id
  private_ips       = each.value.private_ip == null ? [] : [each.value.private_ip]
  security_groups   = each.value.security_groups
  source_dest_check = false

  tags = merge(local.tags, {
    Name                   = "${local.name}-${each.key}-eni"
    FortiGateInterfaceRole = each.value.interface.role
    FortiGatePort          = "port${each.value.interface.device_index + 1}"
  })
}

resource "aws_instance" "this" {
  for_each = toset(local.node_suffixes)

  ami                         = local.ami_id
  instance_type               = var.instance_type
  subnet_id                   = local.primary_node_interfaces["${each.value}-${local.primary_interface_name}"].subnet_id
  private_ip                  = local.primary_node_interfaces["${each.value}-${local.primary_interface_name}"].private_ip
  vpc_security_group_ids      = local.primary_node_interfaces["${each.value}-${local.primary_interface_name}"].security_groups
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = var.iam_instance_profile_name
  key_name                    = var.key_name
  monitoring                  = var.monitoring
  ebs_optimized               = var.ebs_optimized
  disable_api_termination     = var.disable_api_termination
  source_dest_check           = false
  user_data_base64            = try(base64encode(local.user_data[each.value]), null)
  user_data_replace_on_change = var.user_data_replace_on_change
  tags                        = merge(local.tags, { Name = "${local.name}-${each.value}" })
  volume_tags                 = merge(local.tags, { Name = "${local.name}-${each.value}-root" })

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
  }

  lifecycle {
    precondition {
      condition     = !var.associate_public_ip_address || var.allow_public_ip
      error_message = "Public IP assignment requires allow_public_ip = true."
    }

    precondition {
      condition     = var.environment != "prod" || !var.associate_public_ip_address
      error_message = "Production FortiGate instances cannot receive public IPs."
    }

    precondition {
      condition     = local.primary_node_interfaces["${each.value}-${local.primary_interface_name}"].subnet_id != ""
      error_message = "Every FortiGate node requires a subnet for its primary interface."
    }

    precondition {
      condition     = local.primary_node_interfaces["${each.value}-${local.primary_interface_name}"].security_groups != null && length(local.primary_node_interfaces["${each.value}-${local.primary_interface_name}"].security_groups) > 0
      error_message = "Every FortiGate primary interface requires at least one security group."
    }
  }
}

resource "aws_network_interface_attachment" "additional" {
  for_each = local.additional_node_interfaces

  instance_id          = aws_instance.this[each.value.node_suffix].id
  network_interface_id = aws_network_interface.additional[each.key].id
  device_index         = each.value.interface.device_index
}
