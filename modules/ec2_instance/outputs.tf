output "instance_id" {
  description = "EC2 instance ID."
  value       = aws_instance.this.id
}

output "instance_arn" {
  description = "EC2 instance ARN."
  value       = aws_instance.this.arn
}

output "name" {
  description = "Resolved instance name."
  value       = local.name
}

output "private_ip" {
  description = "Primary private IPv4 address."
  value       = aws_instance.this.private_ip
}

output "private_dns" {
  description = "Private DNS name."
  value       = aws_instance.this.private_dns
}

output "public_ip" {
  description = "Public IPv4 address, or an empty value when none is assigned."
  value       = aws_instance.this.public_ip
}

output "availability_zone" {
  description = "Availability Zone containing the instance."
  value       = aws_instance.this.availability_zone
}
