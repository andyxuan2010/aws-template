output "cluster_name" {
  description = "EKS cluster name."
  value       = aws_eks_cluster.this.name
}
output "cluster_arn" {
  description = "EKS cluster ARN."
  value       = aws_eks_cluster.this.arn
}
output "cluster_endpoint" {
  description = "Kubernetes API endpoint."
  value       = aws_eks_cluster.this.endpoint
}
output "cluster_certificate_authority_data" {
  description = "Cluster certificate authority data."
  value       = aws_eks_cluster.this.certificate_authority[0].data
}
output "node_group_arns" {
  description = "Managed node group ARNs keyed by stable logical name."
  value = { for key, group in aws_eks_node_group.this : key => group.arn
  }
}
output "addon_arns" {
  description = "Managed add-on ARNs keyed by add-on name."
  value = { for key, addon in aws_eks_addon.this : key => addon.arn
  }
}
