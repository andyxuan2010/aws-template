output "name" {
  description = "Resolved FortiGate resource name prefix."
  value       = local.name
}

output "architecture" {
  description = "Effective FortiGate architecture."
  value       = local.architecture
}

output "ami_id" {
  description = "AMI ID used by the FortiGate instances."
  value       = local.ami_id
}

output "instance_ids" {
  description = "FortiGate EC2 instance IDs keyed by node suffix."
  value       = { for suffix, instance in aws_instance.this : suffix => instance.id }
}

output "instance_arns" {
  description = "FortiGate EC2 instance ARNs keyed by node suffix."
  value       = { for suffix, instance in aws_instance.this : suffix => instance.arn }
}

output "instance_private_ips" {
  description = "Primary private IP addresses keyed by node suffix."
  value       = { for suffix, instance in aws_instance.this : suffix => instance.private_ip }
}

output "instance_public_ips" {
  description = "Primary public IP addresses keyed by node suffix, when public IP assignment is explicitly enabled."
  value       = { for suffix, instance in aws_instance.this : suffix => instance.public_ip }
}

output "network_interface_ids" {
  description = "Additional ENI IDs keyed by <node>-<interface>; primary ENI IDs are exposed separately."
  value       = { for key, eni in aws_network_interface.additional : key => eni.id }
}

output "network_interface_private_ips" {
  description = "Additional ENI primary private IP addresses keyed by <node>-<interface>; use the FortiGate traffic-interface IPs as GWLB targets."
  value       = { for key, eni in aws_network_interface.additional : key => eni.private_ip }
}

output "primary_network_interface_ids" {
  description = "Primary ENI IDs keyed by node suffix."
  value       = { for suffix, instance in aws_instance.this : suffix => instance.primary_network_interface_id }
}

output "interface_order" {
  description = "Effective interface order by logical interface name. Device indexes remain authoritative for FortiOS port mapping."
  value       = local.interface_order
}

output "bootstrap_applied" {
  description = "Whether FortiOS user data was generated for the instances."
  value       = { for suffix in local.node_suffixes : suffix => nonsensitive(contains(keys(local.user_data), suffix)) }
}
