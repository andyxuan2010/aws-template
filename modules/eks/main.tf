resource "aws_eks_cluster" "this" {
  name                      = local.name
  role_arn                  = var.cluster_role_arn
  version                   = var.kubernetes_version
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  tags                      = local.tags

  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = var.cluster_security_group_ids
    endpoint_private_access = true
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.endpoint_public_access ? var.endpoint_public_access_cidrs : null

  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = false

  }

  encryption_config {
    provider {
      key_arn = var.kms_key_arn
    }
    resources = ["secrets"]
  }

  lifecycle {
    precondition {
      condition     = !var.endpoint_public_access || (length(var.endpoint_public_access_cidrs) > 0 && !contains(var.endpoint_public_access_cidrs, "0.0.0.0/0") && !contains(var.endpoint_public_access_cidrs, "::/0"))
      error_message = "Public endpoint access requires explicit CIDRs and must not allow all IPv4 or IPv6 addresses."

    }

  }
}

resource "aws_eks_access_entry" "admin" {
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = var.admin_role_arn
  type          = "STANDARD"
  tags          = local.tags
}

resource "aws_eks_access_policy_association" "admin" {
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = aws_eks_access_entry.admin.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  access_scope {
    type = "cluster"

  }
}

resource "aws_eks_node_group" "this" {
  for_each        = var.node_groups
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${local.name}-${each.key}"
  node_role_arn   = each.value.node_role_arn
  subnet_ids      = each.value.subnet_ids == null ? var.subnet_ids : each.value.subnet_ids
  instance_types  = each.value.instance_types
  capacity_type   = each.value.capacity_type
  disk_size       = each.value.disk_size
  version         = var.kubernetes_version
  tags            = merge(local.tags, { Name = "${local.name}-${each.key}" })

  scaling_config {
    min_size     = each.value.min_size
    desired_size = each.value.desired_size
    max_size     = each.value.max_size

  }
  update_config {
    max_unavailable = 1

  }
  lifecycle {
    precondition {
      condition     = each.value.min_size <= each.value.desired_size && each.value.desired_size <= each.value.max_size
      error_message = "Node group capacity must satisfy min_size <= desired_size <= max_size."

    }

  }
}

resource "aws_eks_addon" "this" {
  for_each                    = var.addons
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = each.key
  addon_version               = each.value.addon_version
  resolve_conflicts_on_create = "NONE"
  resolve_conflicts_on_update = "PRESERVE"
  tags                        = merge(local.tags, { Name = "${local.name}-${each.key}" })
}
