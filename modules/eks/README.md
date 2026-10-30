# EKS module

Creates an Amazon EKS control plane, managed node groups, managed add-ons,
cluster logging, and an explicit cluster-admin access entry. IAM roles and
policies, VPC, node security groups, and Kubernetes workloads are caller-owned.

## Secure defaults

- Enables the private API endpoint and disables public access by default.
- Requires public API CIDRs that are explicit and do not include all IPv4 or
  IPv6 addresses when public access is enabled.
- Sends control-plane audit and API logs to CloudWatch Logs.
- Disables creator bootstrap-admin access; grants cluster-admin only to the
  supplied IAM role using the EKS access API.
- Requires customer-managed KMS encryption for Kubernetes secrets.

## Basic usage

```hcl
module "cluster" {
  source = "../../modules/eks"

  workload           = "apps"
  region_code        = "use1"
  environment        = "prod"
  kubernetes_version = "1.37"
  cluster_role_arn   = module.eks_control_plane_role.role_arn
  admin_role_arn     = "arn:aws:iam::123456789012:role/platform-admin"
  kms_key_arn        = module.eks_secrets_key.key_arn
  subnet_ids         = toset(values(module.vpc.private_subnet_ids))
  node_groups = {
    system = {
      node_role_arn  = module.eks_node_role.role_arn
      instance_types = ["m7i.large"]
      min_size       = 2
      desired_size   = 2
      max_size       = 6
    }
  }
  addons = {
    vpc-cni = {}
    coredns = {}
    kube-proxy = {}
  }
}
```

The consuming operator must be able to assume the admin role and reach the
private endpoint. Supply IAM roles with the AWS-recommended EKS trust and
permissions. Pin add-on versions for controlled production rollouts.
The KMS key policy must allow the EKS service to use the key.

Common uses include long-running container workloads that need Kubernetes
APIs, managed worker nodes, and EKS-managed networking or DNS add-ons.

## Costs and operations

The EKS control plane, EC2 nodes, CloudWatch log ingestion/retention, and
supporting networking incur costs. Kubernetes version upgrades and node-group
rollouts can disrupt workloads; use PodDisruptionBudgets and staged upgrades.

Configure AWS credentials and provider in the consuming root. Terraform
`>= 1.6.0`, AWS provider `>= 5.43, < 7.0`.

Generated names and tags follow the repository
[naming](../../docs/60-security-governance/naming-convention.md) and
[tagging](../../docs/60-security-governance/tagging-standard.md) standards.

## Terraform Reference

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.43, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.43, < 7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_access_entry.admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_entry) | resource |
| [aws_eks_access_policy_association.admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_policy_association) | resource |
| [aws_eks_addon.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_addons"></a> [addons](#input\_addons) | EKS managed add-ons keyed by add-on name. Pin versions for controlled upgrades. | <pre>map(object({<br>    addon_version = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_admin_role_arn"></a> [admin\_role\_arn](#input\_admin\_role\_arn) | IAM role ARN that receives EKS cluster-admin access. | `string` | n/a | yes |
| <a name="input_cluster_role_arn"></a> [cluster\_role\_arn](#input\_cluster\_role\_arn) | Caller-managed EKS cluster IAM role ARN. | `string` | n/a | yes |
| <a name="input_cluster_security_group_ids"></a> [cluster\_security\_group\_ids](#input\_cluster\_security\_group\_ids) | Optional additional cluster security group IDs. | `set(string)` | `[]` | no |
| <a name="input_endpoint_public_access"></a> [endpoint\_public\_access](#input\_endpoint\_public\_access) | Enable the public Kubernetes API endpoint. | `bool` | `false` | no |
| <a name="input_endpoint_public_access_cidrs"></a> [endpoint\_public\_access\_cidrs](#input\_endpoint\_public\_access\_cidrs) | CIDRs allowed to reach the public endpoint; required and restricted when public access is enabled. | `set(string)` | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | Customer-managed KMS key ARN for Kubernetes secret encryption. | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Explicit supported Kubernetes version. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | EKS cluster name; generated when empty. | `string` | `""` | no |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | Managed node groups keyed by stable logical name. | <pre>map(object({<br>    node_role_arn  = string<br>    subnet_ids     = optional(set(string))<br>    instance_types = set(string)<br>    capacity_type  = optional(string, "ON_DEMAND")<br>    min_size       = number<br>    desired_size   = number<br>    max_size       = number<br>    disk_size      = optional(number, 50)<br>  }))</pre> | `{}` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short AWS Region code. | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Private subnet IDs across at least two Availability Zones. | `set(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource-specific tags. | `map(string)` | `{}` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_addon_arns"></a> [addon\_arns](#output\_addon\_arns) | Managed add-on ARNs keyed by add-on name. |
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | EKS cluster ARN. |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | Cluster certificate authority data. |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Kubernetes API endpoint. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | EKS cluster name. |
| <a name="output_node_group_arns"></a> [node\_group\_arns](#output\_node\_group\_arns) | Managed node group ARNs keyed by stable logical name. |
<!-- END_TF_DOCS -->
