# EKS Architecture

```mermaid
flowchart LR
  Caller["Calling root module"] --> Module["eks module"]
  Module --> R1["aws_eks_cluster"]
  Module --> R2["aws_eks_access_entry"]
  Module --> R3["aws_eks_access_policy_association"]
  Module --> R4["aws_eks_node_group"]
  Module --> R5["aws_eks_addon"]
```

The eks module declares 5 managed resource type(s), including `aws_eks_cluster`, `aws_eks_access_entry`, `aws_eks_access_policy_association`, `aws_eks_node_group`, `aws_eks_addon`.

Resources that use `count` or `for_each` are gated by inputs such as `node_groups`, `addons`. Review those inputs to see which optional components a deployment creates.

The module accepts 17 input(s), with 6 required.
It returns 6 output(s), including `cluster_name`, `cluster_arn`, `cluster_endpoint`, `cluster_certificate_authority_data`, `node_group_arns`, `addon_arns`. Pass these to downstream modules instead of recreating the resources in the caller.

The caller owns the surrounding infrastructure, such as the resource group, networks, identities, and key or log destinations that this module references. See the [module README](../README.md) for inputs and usage.
